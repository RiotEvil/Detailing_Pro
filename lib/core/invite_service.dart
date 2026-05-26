import 'dart:convert';
import 'dart:io' show ContentType, HttpClient, HttpHeaders;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static const String _functionsRegion = 'europe-west3';

  static bool get _firebaseReady => Firebase.apps.isNotEmpty;

  static InviteException _mapInviteError(String code, {int? seatLimit}) {
    switch (code) {
      case 'seat-limit-reached':
        final limit = seatLimit ?? 1;
        return InviteException(
          'Лимит мест в команде достигнут ($limit). Team seat limit reached ($limit).',
        );
      case 'invalid-code-format':
      case 'invalid-invite-code':
        return const InviteException('Invalid invite code');
      case 'invite-already-used':
        return const InviteException('This invite code has already been used');
      case 'unauthorized':
      case 'forbidden':
      case 'forbidden-org':
      case 'forbidden-director':
      case 'forbidden-user':
      case 'user-already-in-other-org':
        return const InviteException(
          'You do not have permission to perform this action',
        );
      default:
        return const InviteException('Unable to process invite request');
    }
  }

  static Future<Map<String, dynamic>> _postInviteEndpoint({
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const InviteException(
        'You do not have permission to perform this action',
      );
    }

    final projectId = Firebase.app().options.projectId;
    if (projectId.isEmpty) {
      throw const InviteException('Unable to process invite request');
    }

    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw const InviteException(
        'You do not have permission to perform this action',
      );
    }

    final uri = Uri.parse(
      'https://$_functionsRegion-$projectId.cloudfunctions.net/$endpoint',
    );
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.postUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $idToken');
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode(jsonEncode(payload)));

      final response = await request.close().timeout(
        const Duration(seconds: 20),
      );
      final body = await utf8.decoder.bind(response).join();

      Map<String, dynamic> json = <String, dynamic>{};
      if (body.trim().isNotEmpty) {
        final parsed = jsonDecode(body);
        if (parsed is Map<String, dynamic>) {
          json = parsed;
        }
      }

      if (response.statusCode != 200) {
        final code = json['error']?.toString() ?? 'internal';
        final seatLimit = (json['seatLimit'] as num?)?.toInt();
        throw _mapInviteError(code, seatLimit: seatLimit);
      }

      return json;
    } on InviteException {
      rethrow;
    } catch (_) {
      throw const InviteException('Unable to process invite request');
    } finally {
      client.close(force: true);
    }
  }

  /// Генерирует 6-значный инвайт-код и сохраняет его в Firestore.
  /// Возвращает сгенерированный код.
  static Future<String> generateInviteCode({
    required String orgId,
    required String directorUid,
  }) async {
    if (!_firebaseReady) throw Exception('Firebase is not initialized');
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid != directorUid) {
      throw const InviteException(
        'You do not have permission to perform this action',
      );
    }

    final response = await _postInviteEndpoint(
      endpoint: 'generateInviteCode',
      payload: {'orgId': orgId, 'directorUid': directorUid},
    );

    final code = response['code']?.toString() ?? '';
    if (code.isEmpty) {
      throw const InviteException('Unable to process invite request');
    }
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.uid != userUid) {
      throw const InviteException(
        'You do not have permission to perform this action',
      );
    }

    final response = await _postInviteEndpoint(
      endpoint: 'joinWithInviteCode',
      payload: {'code': normalizedCode, 'userUid': userUid},
    );

    final orgId = response['orgId']?.toString() ?? '';
    if (orgId.isEmpty) {
      throw const InviteException('Unable to process invite request');
    }

    return orgId;
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
