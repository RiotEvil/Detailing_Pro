import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'constants.dart';

/// Persists failed Firestore writes to Hive so they can be retried on next
/// app start or network reconnect — preventing data loss on reinstall.
class WriteQueue {
  WriteQueue._();

  static const _maxRetries = 3;
  static const _deadPrefix = 'dead::';
  static const _tsFields = {'timestamp', 'scheduledDate', 'createdAt'};

  static final ValueNotifier<int> pendingCountNotifier = ValueNotifier(0);
  static final ValueNotifier<int> failedCountNotifier = ValueNotifier(0);

  static Box? get _maybeBox =>
      Hive.isBoxOpen(HiveBoxes.pendingWrites)
          ? Hive.box(HiveBoxes.pendingWrites)
          : null;

  static int get pendingCount => _countLiveEntries();
  static int get failedCount => _countDeadEntries();

  static void _refreshNotifiers() {
    pendingCountNotifier.value = pendingCount;
    failedCountNotifier.value = failedCount;
  }

  static bool _isDeadKey(dynamic key) => key.toString().startsWith(_deadPrefix);

  static String _liveKey(String collection, String docId) =>
      '${collection}_$docId';

  static String _deadKey(String liveKey) => '$_deadPrefix$liveKey';

  static int _countLiveEntries() {
    final box = _maybeBox;
    if (box == null) return 0;
    var count = 0;
    for (final key in box.keys) {
      if (!_isDeadKey(key)) count++;
    }
    return count;
  }

  static int _countDeadEntries() {
    final box = _maybeBox;
    if (box == null) return 0;
    var count = 0;
    for (final key in box.keys) {
      if (_isDeadKey(key)) count++;
    }
    return count;
  }

  /// Queue a set (upsert) operation. Deduplicates by [collection]+[docId].
  static Future<void> enqueueSet({
    required String orgId,
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    final box = _maybeBox;
    if (box == null) return;

    final key = _liveKey(collection, docId);
    await box.delete(_deadKey(key));
    await box.put(key, {
      'op': 'set',
      'orgId': orgId,
      'collection': collection,
      'docId': docId,
      'data': jsonEncode(data),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'retryCount': 0,
    });
    _refreshNotifiers();
    debugPrint('[WriteQueue] enqueued set $collection/$docId');
  }

  /// Queue a delete operation. Deduplicates by [collection]+[docId].
  static Future<void> enqueueDelete({
    required String orgId,
    required String collection,
    required String docId,
  }) async {
    final box = _maybeBox;
    if (box == null) return;

    final key = _liveKey(collection, docId);
    await box.delete(_deadKey(key));
    await box.put(key, {
      'op': 'delete',
      'orgId': orgId,
      'collection': collection,
      'docId': docId,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'retryCount': 0,
    });
    _refreshNotifiers();
    debugPrint('[WriteQueue] enqueued delete $collection/$docId');
  }

  /// Attempt to flush all pending writes. Call on sync start or reconnect.
  static Future<void> flush() async {
    final box = _maybeBox;
    if (box == null || _countLiveEntries() == 0) return;

    final db = FirebaseFirestore.instance;
    final keys = box.keys.where((key) => !_isDeadKey(key)).toList();
    var flushed = 0;

    for (final key in keys) {
      final raw = box.get(key);
      if (raw is! Map) {
        await box.delete(key);
        continue;
      }

      final entry = Map<String, dynamic>.from(raw);
      final op = entry['op']?.toString();
      final orgId = entry['orgId']?.toString() ?? '';
      final collection = entry['collection']?.toString() ?? '';
      final docId = entry['docId']?.toString() ?? '';

      if (orgId.isEmpty || collection.isEmpty || docId.isEmpty) {
        await box.delete(key);
        continue;
      }

      final docRef = db
          .collection('organizations')
          .doc(orgId)
          .collection(collection)
          .doc(docId);

      try {
        if (op == 'set') {
          final jsonStr = entry['data'] as String?;
          if (jsonStr == null) {
            await box.delete(key);
            continue;
          }
          final data = Map<String, dynamic>.from(jsonDecode(jsonStr) as Map);
          await docRef.set(_applyTimestamps(data), SetOptions(merge: true));
        } else if (op == 'delete') {
          await docRef.delete();
        } else {
          await box.delete(key);
          continue;
        }
        await box.delete(key);
        flushed++;
      } catch (e) {
        if (_isPermissionDenied(e)) {
          await _moveToDeadLetter(box, key.toString(), entry, e);
          continue;
        }

        final retries = (entry['retryCount'] as int? ?? 0) + 1;
        if (retries >= _maxRetries) {
          debugPrint(
            '[WriteQueue] moving $op $collection/$docId to dead letter after $retries retries: $e',
          );
          await _moveToDeadLetter(box, key.toString(), entry, e);
        } else {
          entry['retryCount'] = retries;
          await box.put(key, entry);
          debugPrint(
            '[WriteQueue] retry $retries/$_maxRetries for $collection/$docId: $e',
          );
        }
      }
    }

    _refreshNotifiers();
    if (flushed > 0) {
      debugPrint('[WriteQueue] flushed $flushed pending write(s)');
    }
  }

  /// Re-queue all dead-letter entries and attempt another flush.
  static Future<void> retryFailed() async {
    final box = _maybeBox;
    if (box == null) return;

    final deadKeys = box.keys.where(_isDeadKey).toList();
    for (final deadKey in deadKeys) {
      final raw = box.get(deadKey);
      if (raw is! Map) {
        await box.delete(deadKey);
        continue;
      }

      final entry = Map<String, dynamic>.from(raw);
      entry.remove('failedAt');
      entry.remove('lastError');
      entry['retryCount'] = 0;

      final liveKey = deadKey.toString().substring(_deadPrefix.length);
      await box.put(liveKey, entry);
      await box.delete(deadKey);
    }

    _refreshNotifiers();
    await flush();
  }

  /// Permanently discard all dead-letter entries.
  static Future<void> discardFailed() async {
    final box = _maybeBox;
    if (box == null) return;

    final deadKeys = box.keys.where(_isDeadKey).toList();
    for (final key in deadKeys) {
      await box.delete(key);
    }
    _refreshNotifiers();
  }

  static Future<void> _moveToDeadLetter(
    Box box,
    String liveKey,
    Map<String, dynamic> entry,
    Object error,
  ) async {
    final dead = Map<String, dynamic>.from(entry)
      ..['failedAt'] = DateTime.now().millisecondsSinceEpoch
      ..['lastError'] = error.toString();
    await box.put(_deadKey(liveKey), dead);
    await box.delete(liveKey);
    _refreshNotifiers();
  }

  static bool _isPermissionDenied(Object e) {
    if (e is FirebaseException) {
      return e.code == 'permission-denied';
    }
    return false;
  }

  static Map<String, dynamic> _applyTimestamps(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    for (final e in data.entries) {
      final v = e.value;
      if (_tsFields.contains(e.key) && v is int) {
        result[e.key] = Timestamp.fromMillisecondsSinceEpoch(v);
      } else {
        result[e.key] = v;
      }
    }
    return result;
  }
}
