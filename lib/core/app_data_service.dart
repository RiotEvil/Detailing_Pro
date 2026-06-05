import 'dart:async';
import 'dart:convert';
import 'dart:io' show ContentType, HttpClient, HttpHeaders;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'cloud_tenant_paths.dart';
import 'constants.dart';
import 'write_queue.dart';

/// Central data service: writes to both Hive (local) and Firestore (cloud).
/// Subscribes to Firestore and mirrors incoming changes to Hive, so every
/// screen that uses ValueListenableBuilder on a Hive box stays live.
class AppDataService {
  AppDataService._();

  static const String _functionsRegion = 'europe-west3';

  static StreamSubscription<QuerySnapshot>? _ordersSub;
  static StreamSubscription<QuerySnapshot>? _clientsSub;
  static StreamSubscription<QuerySnapshot>? _inventorySub;
  static StreamSubscription<QuerySnapshot>? _servicesSub;
  static bool _syncActive = false;

  static String? _lastQuotaOrgId;
  static DateTime? _lastQuotaCheck;
  static const Duration _quotaCacheDuration = Duration(hours: 4);

  /// Notifies the UI when a Firestore stream error occurs (e.g. offline).
  /// Resets to false when sync restarts or is stopped.
  static final ValueNotifier<bool> hasSyncError = ValueNotifier(false);

  /// IDs currently being deleted from Firestore — prevents the snapshot
  /// listener from re-adding them to Hive before the delete completes.
  static final Set<String> _pendingDeleteIds = {};

  static bool get _firebaseReady =>
      Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null;

  static String? get _orgId =>
      Hive.box(HiveBoxes.settings).get('orgId')?.toString();

  // ================================================================
  // LIFECYCLE
  // ================================================================

  static Future<void> startCloudSync() async {
    if (!_firebaseReady || _orgId == null || _syncActive) return;
    _syncActive = true;
    hasSyncError.value = false;
    debugPrint('[DataService] Cloud sync started for org: $_orgId');
    await WriteQueue.flush();
    final now = DateTime.now();
    final orgId = _orgId!;
    if (_lastQuotaOrgId != orgId ||
        _lastQuotaCheck == null ||
        now.difference(_lastQuotaCheck!) > _quotaCacheDuration) {
      await _ensureOrgQuotasOnServer();
      _lastQuotaCheck = now;
      _lastQuotaOrgId = orgId;
    }
    _subscribeOrders();
    _subscribeClients();
    _subscribeInventory();
    _subscribeServices();
  }

  static Future<void> stopCloudSync() async {
    _syncActive = false;
    hasSyncError.value = false;
    await _ordersSub?.cancel();
    await _clientsSub?.cancel();
    await _inventorySub?.cancel();
    await _servicesSub?.cancel();
    _ordersSub = null;
    _clientsSub = null;
    _inventorySub = null;
    _servicesSub = null;
    debugPrint('[DataService] Cloud sync stopped');
  }

  // ================================================================
  // ORDERS
  // ================================================================

  static void _subscribeOrders() {
    final orgId = _orgId;
    if (orgId == null) return;
    _ordersSub = CloudTenantPaths.orders(FirebaseFirestore.instance, orgId)
        .orderBy('timestamp', descending: true)
        .limit(1000)
        .snapshots()
        .listen(
          (snap) {
            hasSyncError.value = false;
            _mirrorToHive(HiveBoxes.orders, snap.docs);
          },
          onError: (e) {
            debugPrint('[DataService] orders sub error: $e');
            hasSyncError.value = true;
          },
        );
  }

  static Future<void> syncOrderToCloud(Map<String, dynamic> orderMap) async {
    if (!_firebaseReady || _orgId == null) return;
    final id = orderMap['id']?.toString();
    if (id == null || id.isEmpty) return;
    try {
      await CloudTenantPaths.orders(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(id).set(_toFirestore(orderMap), SetOptions(merge: true));
    } catch (e) {
      debugPrint('[DataService] syncOrderToCloud error: $e');
      if (_isPermissionDenied(e)) return;
      await WriteQueue.enqueueSet(
        orgId: _orgId!,
        collection: 'orders',
        docId: id,
        data: orderMap,
      );
    }
  }

  static Future<void> deleteOrderFromCloud(String? firestoreId) async {
    if (!_firebaseReady || _orgId == null || firestoreId == null) return;
    _pendingDeleteIds.add(firestoreId);
    try {
      await CloudTenantPaths.orders(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(firestoreId).delete();
    } catch (e) {
      debugPrint('[DataService] deleteOrderFromCloud error: $e');
      if (!_isPermissionDenied(e)) {
        await WriteQueue.enqueueDelete(
          orgId: _orgId!,
          collection: 'orders',
          docId: firestoreId,
        );
      }
    } finally {
      _pendingDeleteIds.remove(firestoreId);
    }
  }

  // ================================================================
  // CLIENTS
  // ================================================================

  static void _subscribeClients() {
    final orgId = _orgId;
    if (orgId == null) return;
    _clientsSub = CloudTenantPaths.clients(FirebaseFirestore.instance, orgId)
        .limit(1000)
        .snapshots()
        .listen(
          (snap) {
            hasSyncError.value = false;
            _mirrorToHive(HiveBoxes.clients, snap.docs);
          },
          onError: (e) {
            debugPrint('[DataService] clients sub error: $e');
            hasSyncError.value = true;
          },
        );
  }

  static Future<void> syncClientToCloud(Map<String, dynamic> clientMap) async {
    if (!_firebaseReady || _orgId == null) return;
    final id = clientMap['id']?.toString();
    if (id == null || id.isEmpty) return;
    try {
      await CloudTenantPaths.clients(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(id).set(_toFirestore(clientMap), SetOptions(merge: true));
    } catch (e) {
      debugPrint('[DataService] syncClientToCloud error: $e');
      if (_isPermissionDenied(e)) return;
      await WriteQueue.enqueueSet(
        orgId: _orgId!,
        collection: 'clients',
        docId: id,
        data: clientMap,
      );
    }
  }

  static Future<void> deleteClientFromCloud(String? clientId) async {
    if (!_firebaseReady || _orgId == null || clientId == null) return;
    try {
      await CloudTenantPaths.clients(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(clientId).delete();
    } catch (e) {
      debugPrint('[DataService] deleteClientFromCloud error: $e');
      if (!_isPermissionDenied(e)) {
        await WriteQueue.enqueueDelete(
          orgId: _orgId!,
          collection: 'clients',
          docId: clientId,
        );
      }
    }
  }

  // ================================================================
  // INVENTORY
  // ================================================================

  static void _subscribeInventory() {
    final orgId = _orgId;
    if (orgId == null) return;
    _inventorySub =
        CloudTenantPaths.inventory(
          FirebaseFirestore.instance,
          orgId,
        ).limit(500).snapshots().listen(
          (snap) {
            hasSyncError.value = false;
            _mirrorToHive(HiveBoxes.inventory, snap.docs);
          },
          onError: (e) {
            debugPrint('[DataService] inventory sub error: $e');
            hasSyncError.value = true;
          },
        );
  }

  static Future<void> syncInventoryItemToCloud(
    Map<String, dynamic> itemMap,
  ) async {
    if (!_firebaseReady || _orgId == null) return;
    final id = itemMap['id']?.toString();
    if (id == null || id.isEmpty) return;
    try {
      await CloudTenantPaths.inventory(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(id).set(itemMap, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[DataService] syncInventoryToCloud error: $e');
      await WriteQueue.enqueueSet(
        orgId: _orgId!,
        collection: 'inventory',
        docId: id,
        data: itemMap,
      );
    }
  }

  static Future<void> deleteInventoryFromCloud(String? itemId) async {
    if (!_firebaseReady || _orgId == null || itemId == null) return;
    try {
      await CloudTenantPaths.inventory(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(itemId).delete();
    } catch (e) {
      debugPrint('[DataService] deleteInventoryFromCloud error: $e');
      await WriteQueue.enqueueDelete(
        orgId: _orgId!,
        collection: 'inventory',
        docId: itemId,
      );
    }
  }

  // ================================================================
  // SERVICES
  // ================================================================

  static void _subscribeServices() {
    final orgId = _orgId;
    if (orgId == null) return;
    _servicesSub = CloudTenantPaths.services(FirebaseFirestore.instance, orgId)
        .limit(200)
        .snapshots()
        .listen(
          (snap) {
            hasSyncError.value = false;
            _mirrorToHive(HiveBoxes.services, snap.docs);
          },
          onError: (e) {
            debugPrint('[DataService] services sub error: $e');
            hasSyncError.value = true;
          },
        );
  }

  static Future<void> syncServiceToCloud(
    Map<String, dynamic> serviceMap,
  ) async {
    if (!_firebaseReady || _orgId == null) return;
    final id = serviceMap['id']?.toString();
    if (id == null || id.isEmpty) return;
    try {
      await CloudTenantPaths.services(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(id).set(_toFirestore(serviceMap), SetOptions(merge: true));
    } catch (e) {
      debugPrint('[DataService] syncServiceToCloud error: $e');
      await WriteQueue.enqueueSet(
        orgId: _orgId!,
        collection: 'services',
        docId: id,
        data: serviceMap,
      );
    }
  }

  static Future<void> deleteServiceFromCloud(String? serviceId) async {
    if (!_firebaseReady || _orgId == null || serviceId == null) return;
    try {
      await CloudTenantPaths.services(
        FirebaseFirestore.instance,
        _orgId!,
      ).doc(serviceId).delete();
    } catch (e) {
      debugPrint('[DataService] deleteServiceFromCloud error: $e');
      await WriteQueue.enqueueDelete(
        orgId: _orgId!,
        collection: 'services',
        docId: serviceId,
      );
    }
  }

  // ================================================================
  // FCM TOKEN
  // ================================================================

  static Future<void> saveFcmToken(String token) async {
    if (!_firebaseReady) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('[DataService] FCM token saved');
    } catch (e) {
      debugPrint('[DataService] saveFcmToken error: $e');
    }
  }

  // ================================================================
  // HELPERS
  // ================================================================

  static bool _isPermissionDenied(Object e) {
    if (e is FirebaseException) {
      return e.code == 'permission-denied';
    }
    return false;
  }

  /// Full recount of quota counters on the server (Admin SDK).
  static Future<void> _ensureOrgQuotasOnServer() async {
    if (!_firebaseReady) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final projectId = Firebase.app().options.projectId;
    if (projectId.isEmpty) return;

    String? idToken;
    try {
      idToken = await user.getIdToken();
    } on FirebaseAuthException {
      return;
    }
    if (idToken == null || idToken.isEmpty) return;

    final uri = Uri.parse(
      'https://$_functionsRegion-$projectId.cloudfunctions.net/ensureOrgQuotas',
    );
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $idToken');
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode('{}'));
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      if (response.statusCode != 200) {
        debugPrint(
          '[DataService] ensureOrgQuotas failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('[DataService] ensureOrgQuotas error: $e');
    } finally {
      client.close(force: true);
    }
  }

  /// Mirror Firestore snapshot docs to a Hive box (upsert by 'id' field).
  static void _mirrorToHive(
    String boxName,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final box = Hive.box(boxName);
    final cloudIds = docs.map((d) => d.id).toSet();

    // Build local index once to avoid scanning all keys per document.
    final idToKey = <String, dynamic>{};
    for (final key in box.keys) {
      final raw = box.get(key);
      if (raw is! Map) continue;
      final id = raw['id']?.toString();
      if (id == null || id.isEmpty) continue;
      idToKey[id] = key;
    }

    for (final doc in docs) {
      // Skip documents that are currently being deleted to avoid re-adding
      // them before the Firestore delete completes (race condition fix).
      if (_pendingDeleteIds.contains(doc.id)) continue;

      final hiveData = _fromFirestore(doc.data());
      hiveData['id'] = doc.id;

      final existingKey = idToKey[doc.id];

      if (existingKey != null) {
        box.put(existingKey, hiveData);
      } else {
        box.add(hiveData);
      }
    }

    // Reconcile remote deletions: remove local entries that no longer exist
    // in Firestore for this synchronized box.
    for (final entry in idToKey.entries) {
      if (!cloudIds.contains(entry.key)) {
        box.delete(entry.value);
      }
    }
  }

  /// Convert int epoch timestamps → Firestore Timestamps before writing.
  static Map<String, dynamic> _toFirestore(Map<String, dynamic> data) {
    const tsFields = {'timestamp', 'scheduledDate', 'createdAt'};
    final result = <String, dynamic>{};
    for (final e in data.entries) {
      final v = e.value;
      if (tsFields.contains(e.key) && v is int) {
        result[e.key] = Timestamp.fromMillisecondsSinceEpoch(v);
      } else {
        result[e.key] = v;
      }
    }
    return result;
  }

  /// Convert Firestore Timestamps → int epoch after reading.
  static Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    final result = <String, dynamic>{};
    for (final e in data.entries) {
      final v = e.value;
      if (v is Timestamp) {
        result[e.key] = v.millisecondsSinceEpoch;
      } else if (v is Map<String, dynamic>) {
        result[e.key] = _fromFirestore(v);
      } else {
        result[e.key] = v;
      }
    }
    return result;
  }
}
