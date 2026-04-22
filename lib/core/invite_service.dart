import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Typed exception thrown by [InviteService] for user-facing error messages.
class InviteException implements Exception {
  final String message;
  const InviteException(this.message);
  @override
  String toString() => message;
}

/// Отвечает за генерацию и валидацию инвайт-кодов для команды.
///
/// Структура документа в Firestore: `invites/{code}`
/// ```json
/// {
///   "code": "ABC123",
///   "orgId": "org_xxx",
///   "directorUid": "uid_xxx",
///   "used": false,
///   "usedBy": null,
///   "createdAt": Timestamp,
///   "usedAt": null
/// }
/// ```
class InviteService {
  InviteService._();

  // Алфавит без похожих символов (0/O, 1/I/l) для удобства набора
  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static bool get _firebaseReady => Firebase.apps.isNotEmpty;

  /// Генерирует 6-значный инвайт-код и сохраняет его в Firestore.
  /// Возвращает сгенерированный код.
  static Future<String> generateInviteCode({
    required String orgId,
    required String directorUid,
  }) async {
    if (!_firebaseReady) throw Exception('Firebase is not initialized');

    final rng = Random.secure();
    final code = List.generate(
      6,
      (_) => _chars[rng.nextInt(_chars.length)],
    ).join();

    await FirebaseFirestore.instance.collection('invites').doc(code).set({
      'code': code,
      'orgId': orgId,
      'directorUid': directorUid,
      'used': false,
      'usedBy': null,
      'createdAt': FieldValue.serverTimestamp(),
      'usedAt': null,
    });

    return code;
  }

  /// Проверяет инвайт-код и атомарно привязывает пользователя к организации.
  ///
  /// При успехе возвращает `orgId` организации.
  /// При ошибке выбрасывает [InviteException] с понятным сообщением для UI.
  static Future<String> validateAndJoinOrg({
    required String code,
    required String userUid,
  }) async {
    if (!_firebaseReady) throw Exception('Firebase is not initialized');

    final normalizedCode = code.trim().toUpperCase();
    if (normalizedCode.length != 6) {
      throw const InviteException('Invite code must be exactly 6 characters');
    }

    final firestore = FirebaseFirestore.instance;

    return firestore.runTransaction<String>((tx) async {
      final inviteRef = firestore.collection('invites').doc(normalizedCode);
      final inviteSnap = await tx.get(inviteRef);

      if (!inviteSnap.exists) {
        throw const InviteException('Invalid invite code');
      }

      final data = inviteSnap.data()!;
      if (data['used'] == true) {
        throw const InviteException('This invite code has already been used');
      }

      final orgId = data['orgId'] as String;

      // Помечаем код как использованный
      tx.update(inviteRef, {
        'used': true,
        'usedBy': userUid,
        'usedAt': FieldValue.serverTimestamp(),
      });

      // Привязываем пользователя к организации с ролью мастера
      final userRef = firestore.collection('users').doc(userUid);
      tx.set(userRef, {
        'orgId': orgId,
        'role': 'master',
        'businessMode': 'team',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return orgId;
    });
  }

  /// Возвращает список активных (неиспользованных) инвайтов для организации.
  static Future<List<Map<String, dynamic>>> getActiveInvites(
    String orgId,
  ) async {
    if (!_firebaseReady) return [];

    final snap = await FirebaseFirestore.instance
        .collection('invites')
        .where('orgId', isEqualTo: orgId)
        .where('used', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }
}
