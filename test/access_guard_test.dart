import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/core/access_guard.dart';
import 'package:flutter_application_1/core/constants.dart';

// Helpers to configure Hive settings box before each test.
void _setPlan(AppPlan plan, PlanStatus status) {
  final box = Hive.box(HiveBoxes.settings);
  box.put('appPlan', plan.name);
  box.put('planStatus', status.name);
}

void _setRole(AppRole role) {
  Hive.box(HiveBoxes.settings).put('appRole', role.name);
}

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hive_access_guard_');
    Hive.init(dir.path);
    await Hive.openBox(HiveBoxes.settings);
    await Hive.openBox(HiveBoxes.clients);
  });

  setUp(() {
    Hive.box(HiveBoxes.settings).clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('AccessGuard.countClients', () {
    test('counts only records with a non-empty id', () {
      final box = Hive.box(HiveBoxes.clients);
      box.clear();
      box.add({'name': 'no id'});
      box.add({'id': '', 'name': 'empty id'});
      box.add({'id': 'client_1', 'name': 'Alice'});

      expect(AccessGuard.countClients(box), 1);
    });
  });

  // ────────────────────────────────────────────────────────
  // canCreateClient
  // ────────────────────────────────────────────────────────
  group('AccessGuard.canCreateClient', () {
    test('free plan: allows when below limit', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 19), isTrue);
    });

    test('free plan: blocks at exact limit (20)', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 20), isFalse);
    });

    test('free plan: blocks above limit', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 150), isFalse);
    });

    test('free plan: editing always allowed regardless of count', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateClient(existingClientsCount: 500, isEditing: true),
        isTrue,
      );
    });

    test('pro + active plan: bypasses limit', () {
      _setPlan(AppPlan.pro, PlanStatus.active);
      expect(AccessGuard.canCreateClient(existingClientsCount: 200), isTrue);
    });

    test('pro + trial plan: bypasses limit', () {
      _setPlan(AppPlan.pro, PlanStatus.trial);
      expect(AccessGuard.canCreateClient(existingClientsCount: 200), isTrue);
    });

    test('pro + grace plan: bypasses limit', () {
      _setPlan(AppPlan.pro, PlanStatus.grace);
      expect(AccessGuard.canCreateClient(existingClientsCount: 200), isTrue);
    });

    test('business + active plan: bypasses limit', () {
      _setPlan(AppPlan.business, PlanStatus.active);
      expect(AccessGuard.canCreateClient(existingClientsCount: 500), isTrue);
    });

    test('pro + inactive status still enforces limits', () {
      // Plan is pro but subscription expired (inactive) — limits apply
      _setPlan(AppPlan.pro, PlanStatus.inactive);
      expect(AccessGuard.canCreateClient(existingClientsCount: 20), isFalse);
    });

    test('limit constant is 20', () {
      expect(AccessGuard.freeClientsLimit, 20);
    });
  });

  // ────────────────────────────────────────────────────────
  // canCreateOrderThisMonth
  // ────────────────────────────────────────────────────────
  group('AccessGuard.canCreateOrderThisMonth', () {
    test('free plan: allows when below limit', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 9),
        isTrue,
      );
    });

    test('free plan: blocks at exact limit (10)', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 10),
        isFalse,
      );
    });

    test('free plan: blocks above limit', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 50),
        isFalse,
      );
    });

    test('free plan: editing always allowed regardless of count', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(
        AccessGuard.canCreateOrderThisMonth(
          activeOrdersThisMonthCount: 100,
          isEditing: true,
        ),
        isTrue,
      );
    });

    test('pro + active plan: bypasses limit', () {
      _setPlan(AppPlan.pro, PlanStatus.active);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 100),
        isTrue,
      );
    });

    test('business + active plan: bypasses limit', () {
      _setPlan(AppPlan.business, PlanStatus.active);
      expect(
        AccessGuard.canCreateOrderThisMonth(activeOrdersThisMonthCount: 500),
        isTrue,
      );
    });

    test('limit constant is 10', () {
      expect(AccessGuard.freeActiveOrdersPerMonthLimit, 10);
    });
  });

  // ────────────────────────────────────────────────────────
  // hasProAccess / hasBusinessAccess
  // ────────────────────────────────────────────────────────
  group('AccessGuard.hasProAccess', () {
    test('free + inactive: no access', () {
      _setPlan(AppPlan.free, PlanStatus.inactive);
      expect(AccessGuard.hasProAccess(), isFalse);
    });

    test('pro + active: has access', () {
      _setPlan(AppPlan.pro, PlanStatus.active);
      expect(AccessGuard.hasProAccess(), isTrue);
    });

    test('pro + trial: has access', () {
      _setPlan(AppPlan.pro, PlanStatus.trial);
      expect(AccessGuard.hasProAccess(), isTrue);
    });

    test('pro + inactive: no access (expired subscription)', () {
      _setPlan(AppPlan.pro, PlanStatus.inactive);
      expect(AccessGuard.hasProAccess(), isFalse);
    });

    test('business + active: has pro access', () {
      _setPlan(AppPlan.business, PlanStatus.active);
      expect(AccessGuard.hasProAccess(), isTrue);
    });
  });

  group('AccessGuard.hasBusinessAccess', () {
    test('pro + active: no business access', () {
      _setPlan(AppPlan.pro, PlanStatus.active);
      expect(AccessGuard.hasBusinessAccess(), isFalse);
    });

    test('business + active: has business access', () {
      _setPlan(AppPlan.business, PlanStatus.active);
      expect(AccessGuard.hasBusinessAccess(), isTrue);
    });

    test('business + inactive: no access (expired)', () {
      _setPlan(AppPlan.business, PlanStatus.inactive);
      expect(AccessGuard.hasBusinessAccess(), isFalse);
    });
  });

  // ────────────────────────────────────────────────────────
  // Role-based permissions
  // ────────────────────────────────────────────────────────
  group('AccessGuard role permissions', () {
    test('director can manage business data', () {
      _setRole(AppRole.director);
      expect(AccessGuard.canManageBusinessData(), isTrue);
    });

    test('masterOwner can manage business data', () {
      _setRole(AppRole.masterOwner);
      expect(AccessGuard.canManageBusinessData(), isTrue);
    });

    test('master cannot manage business data', () {
      _setRole(AppRole.master);
      expect(AccessGuard.canManageBusinessData(), isFalse);
    });

    test('master can manage orders and clients', () {
      _setRole(AppRole.master);
      expect(AccessGuard.canManageOrdersAndClients(), isTrue);
    });
  });
}
