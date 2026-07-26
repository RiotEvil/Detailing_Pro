import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/core/access_guard.dart';
import 'package:flutter_application_1/core/constants.dart';

Future<void> _setPlan(AppPlan plan, PlanStatus status) async {
  final box = Hive.box(HiveBoxes.settings);
  await box.put('appPlan', plan.name);
  await box.put('planStatus', status.name);
}

Future<void> _setRole(AppRole role) async {
  await Hive.box(HiveBoxes.settings).put('appRole', role.name);
}

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hive_access_guard_');
    Hive.init(dir.path);
    await Hive.openBox(HiveBoxes.settings);
    await Hive.openBox(HiveBoxes.clients);
  });

  setUp(() async {
    await Hive.box(HiveBoxes.settings).clear();
  });

  tearDownAll(() async {
    try {
      await Hive.close().timeout(const Duration(seconds: 5));
    } catch (_) {}
  });

  group('AccessGuard.countClients', () {
    test('counts only records with a non-empty id', () async {
      final box = Hive.box(HiveBoxes.clients);
      await box.clear();
      await box.add({'name': 'no id'});
      await box.add({'id': '', 'name': 'empty id'});
      await box.add({'id': 'client_1', 'name': 'Alice'});

      expect(AccessGuard.countClients(box), 1);
    });
  });

  group('AccessGuard.canCreateClient', () {
    test('free plan: allows when below limit', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 4), isTrue);
    });

    test('free plan: blocks at exact limit (5)', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 5), isFalse);
    });

    test('free plan: blocks above limit', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 150), isFalse);
    });

    test('free plan: editing always allowed regardless of count', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateClient(existingClientsCount: 500, isEditing: true),
        isTrue,
      );
    });

    test('pro + active plan: bypasses limit', () async {
      await _setPlan(AppPlan.pro, PlanStatus.active);
      expect(AccessGuard.canCreateClient(existingClientsCount: 200), isTrue);
    });

    test('pro + trial plan: bypasses limit', () async {
      await _setPlan(AppPlan.pro, PlanStatus.trial);
      expect(AccessGuard.canCreateClient(existingClientsCount: 200), isTrue);
    });

    test('pro + grace plan: bypasses limit', () async {
      await _setPlan(AppPlan.pro, PlanStatus.grace);
      expect(AccessGuard.canCreateClient(existingClientsCount: 200), isTrue);
    });

    test('business + active plan: bypasses limit', () async {
      await _setPlan(AppPlan.business, PlanStatus.active);
      expect(AccessGuard.canCreateClient(existingClientsCount: 500), isTrue);
    });

    test('pro + inactive status still enforces limits', () async {
      await _setPlan(AppPlan.pro, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 5), isFalse);
    });

    test('limit constant is 5', () {
      expect(AccessGuard.freeClientsLimit, 5);
    });
  });

  group('AccessGuard.canCreateOrderThisMonth', () {
    test('free plan: allows when below limit', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 2),
        isTrue,
      );
    });

    test('free plan: blocks at exact limit (3)', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 3),
        isFalse,
      );
    });

    test('free plan: blocks above limit', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 50),
        isFalse,
      );
    });

    test('free plan: editing always allowed regardless of count', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(
          activeOrdersThisMonthCount: 100,
          isEditing: true,
        ),
        isTrue,
      );
    });

    test('pro + active plan: bypasses limit', () async {
      await _setPlan(AppPlan.pro, PlanStatus.active);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 100),
        isTrue,
      );
    });

    test('business + active plan: bypasses limit', () async {
      await _setPlan(AppPlan.business, PlanStatus.active);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 500),
        isTrue,
      );
    });

    test('limit constant is 3', () {
      expect(AccessGuard.freeActiveOrdersPerMonthLimit, 3);
    });
  });

  group('AccessGuard.hasProAccess', () {
    test('free + inactive: no access', () async {
      await _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.hasProAccess(), isFalse);
    });

    test('pro + active: has access', () async {
      await _setPlan(AppPlan.pro, PlanStatus.active);
      expect(AccessGuard.hasProAccess(), isTrue);
    });

    test('pro + trial: has access', () async {
      await _setPlan(AppPlan.pro, PlanStatus.trial);
      expect(AccessGuard.hasProAccess(), isTrue);
    });

    test('pro + inactive: no access (expired subscription)', () async {
      await _setPlan(AppPlan.pro, PlanStatus.inactive);
      expect(AccessGuard.hasProAccess(), isFalse);
    });

    test('business + active: has pro access', () async {
      await _setPlan(AppPlan.business, PlanStatus.active);
      expect(AccessGuard.hasProAccess(), isTrue);
    });
  });

  group('AccessGuard.hasBusinessAccess', () {
    test('pro + active: no business access', () async {
      await _setPlan(AppPlan.pro, PlanStatus.active);
      expect(AccessGuard.hasBusinessAccess(), isFalse);
    });

    test('business + active: has business access', () async {
      await _setPlan(AppPlan.business, PlanStatus.active);
      expect(AccessGuard.hasBusinessAccess(), isTrue);
    });

    test('business + inactive: no access (expired)', () async {
      await _setPlan(AppPlan.business, PlanStatus.inactive);
      expect(AccessGuard.hasBusinessAccess(), isFalse);
    });
  });

  group('AccessGuard role permissions', () {
    test('director can manage business data', () async {
      await _setRole(AppRole.director);
      expect(AccessGuard.canManageBusinessData(), isTrue);
    });

    test('masterOwner can manage business data', () async {
      await _setRole(AppRole.masterOwner);
      expect(AccessGuard.canManageBusinessData(), isTrue);
    });

    test('master cannot manage business data', () async {
      await _setRole(AppRole.master);
      expect(AccessGuard.canManageBusinessData(), isFalse);
    });

    test('master can manage orders and clients', () async {
      await _setRole(AppRole.master);
      expect(AccessGuard.canManageOrdersAndClients(), isTrue);
    });
  });
}
