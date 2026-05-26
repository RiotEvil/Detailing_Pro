import 'package:hive_flutter/hive_flutter.dart';

class OnboardingPrefs {
  OnboardingPrefs._();

  static const int currentVersion = 1;

  static const String keySchemaVersion = 'onboarding.schemaVersion';
  static const String keyGlobalCompletedVersion =
      'onboarding.globalCompletedVersion';
  static const String keyPreAuthCompleted = 'onboarding.preAuth.completed';
  static const String keyPostAuthCompleted = 'onboarding.postAuth.completed';
  static const String keyDismissCount = 'onboarding.dismissCount';
  static const String keyLastShownAt = 'onboarding.lastShownAt';
  static const String _hintPrefix = 'onboarding.hint.nav.';

  static const List<String> _coreHintIds = [
    'dashboard',
    'orders',
    'clients',
    'settings',
  ];

  static String navHintKey(String navId) => '$_hintPrefix$navId';

  static bool shouldShowPreAuth(Box box) {
    final completed = box.get(keyPreAuthCompleted, defaultValue: false) == true;
    final completedVersion =
        box.get(keyGlobalCompletedVersion, defaultValue: 0) as int;

    if (!completed) {
      return true;
    }

    return completedVersion < currentVersion;
  }

  static Future<void> markPreAuthCompleted(
    Box box, {
    required bool skipped,
  }) async {
    await box.put(keySchemaVersion, currentVersion);
    await box.put(keyPreAuthCompleted, true);
    await box.put(keyGlobalCompletedVersion, currentVersion);
    await box.put(keyLastShownAt, DateTime.now().millisecondsSinceEpoch);

    if (skipped) {
      final dismissCount = box.get(keyDismissCount, defaultValue: 0) as int;
      await box.put(keyDismissCount, dismissCount + 1);
    }
  }

  static Future<void> ensureDefaults(Box box) async {
    if (box.get(keySchemaVersion) == null) {
      await box.put(keySchemaVersion, currentVersion);
    }
    if (box.get(keyGlobalCompletedVersion) == null) {
      await box.put(keyGlobalCompletedVersion, 0);
    }
    if (box.get(keyPreAuthCompleted) == null) {
      await box.put(keyPreAuthCompleted, false);
    }
    if (box.get(keyPostAuthCompleted) == null) {
      await box.put(keyPostAuthCompleted, false);
    }
    if (box.get(keyDismissCount) == null) {
      await box.put(keyDismissCount, 0);
    }
    if (box.get(keyLastShownAt) == null) {
      await box.put(keyLastShownAt, 0);
    }
  }

  static bool isNavHintSeen(Box box, String navId) {
    return box.get(navHintKey(navId), defaultValue: false) == true;
  }

  static Future<void> markNavHintSeen(Box box, String navId) async {
    await box.put(navHintKey(navId), true);

    final completedCoreHints = _coreHintIds.every(
      (id) => isNavHintSeen(box, id),
    );
    if (completedCoreHints) {
      await box.put(keyPostAuthCompleted, true);
    }
  }

  static Future<void> resetForReplay(Box box) async {
    await box.put(keyPreAuthCompleted, false);
    await box.put(keyPostAuthCompleted, false);
    await box.put(keyGlobalCompletedVersion, 0);
    await box.put(keyLastShownAt, 0);

    final keysToDelete = box.keys
        .whereType<String>()
        .where((key) => key.startsWith(_hintPrefix))
        .toList(growable: false);

    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }
}
