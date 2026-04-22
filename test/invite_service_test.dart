import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/invite_service.dart';

void main() {
  // ────────────────────────────────────────────────────────
  // InviteException
  // ────────────────────────────────────────────────────────
  group('InviteException', () {
    test('stores message correctly', () {
      const e = InviteException('bad code');
      expect(e.message, 'bad code');
    });

    test('toString returns message', () {
      const e = InviteException('bad code');
      expect(e.toString(), 'bad code');
    });

    test('is caught by on InviteException', () {
      expect(
        () => throw const InviteException('test'),
        throwsA(isA<InviteException>()),
      );
    });

    test('is caught by on Exception', () {
      expect(
        () => throw const InviteException('test'),
        throwsA(isA<Exception>()),
      );
    });

    test('is NOT caught by on ArgumentError', () {
      expect(
        () => throw const InviteException('test'),
        isNot(throwsA(isA<ArgumentError>())),
      );
    });
  });

  // ────────────────────────────────────────────────────────
  // InviteService — Firebase not initialized
  // ────────────────────────────────────────────────────────
  group('InviteService (no Firebase)', () {
    test(
      'validateAndJoinOrg throws when Firebase is not initialized',
      () async {
        await expectLater(
          InviteService.validateAndJoinOrg(code: 'ABCDEF', userUid: 'uid_123'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      },
    );

    test(
      'generateInviteCode throws when Firebase is not initialized',
      () async {
        await expectLater(
          InviteService.generateInviteCode(
            orgId: 'org_123',
            directorUid: 'uid_123',
          ),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Firebase is not initialized'),
            ),
          ),
        );
      },
    );

    test(
      'getActiveInvites returns empty list when Firebase is not initialized',
      () async {
        final result = await InviteService.getActiveInvites('org_123');
        expect(result, isEmpty);
      },
    );
  });
}
