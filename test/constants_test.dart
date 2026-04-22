import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/constants.dart';

void main() {
  // ────────────────────────────────────────────────────────
  // AppPlan
  // ────────────────────────────────────────────────────────
  group('AppPlan.fromStorage', () {
    test('null returns free', () {
      expect(AppPlan.fromStorage(null), AppPlan.free);
    });

    test('empty string returns free', () {
      expect(AppPlan.fromStorage(''), AppPlan.free);
    });

    test('unknown value returns free', () {
      expect(AppPlan.fromStorage('enterprise'), AppPlan.free);
    });

    test('pro returns pro', () {
      expect(AppPlan.fromStorage('pro'), AppPlan.pro);
    });

    test('business returns business', () {
      expect(AppPlan.fromStorage('business'), AppPlan.business);
    });

    test('free returns free', () {
      expect(AppPlan.fromStorage('free'), AppPlan.free);
    });
  });

  // ────────────────────────────────────────────────────────
  // PlanStatus
  // ────────────────────────────────────────────────────────
  group('PlanStatus.fromStorage', () {
    test('null returns inactive', () {
      expect(PlanStatus.fromStorage(null), PlanStatus.inactive);
    });

    test('empty string returns inactive', () {
      expect(PlanStatus.fromStorage(''), PlanStatus.inactive);
    });

    test('unknown value returns inactive', () {
      expect(PlanStatus.fromStorage('expired'), PlanStatus.inactive);
    });

    test('active returns active', () {
      expect(PlanStatus.fromStorage('active'), PlanStatus.active);
    });

    test('trial returns trial', () {
      expect(PlanStatus.fromStorage('trial'), PlanStatus.trial);
    });

    test('grace returns grace', () {
      expect(PlanStatus.fromStorage('grace'), PlanStatus.grace);
    });
  });

  group('PlanStatus.grantsAccess', () {
    test('inactive does not grant access', () {
      expect(PlanStatus.inactive.grantsAccess, isFalse);
    });

    test('active grants access', () {
      expect(PlanStatus.active.grantsAccess, isTrue);
    });

    test('trial grants access', () {
      expect(PlanStatus.trial.grantsAccess, isTrue);
    });

    test('grace grants access', () {
      expect(PlanStatus.grace.grantsAccess, isTrue);
    });
  });

  // ────────────────────────────────────────────────────────
  // AppRole
  // ────────────────────────────────────────────────────────
  group('AppRole.fromStorage', () {
    test('null in solo mode returns masterOwner', () {
      expect(
        AppRole.fromStorage(null, mode: BusinessMode.solo),
        AppRole.masterOwner,
      );
    });

    test('null in team mode returns director', () {
      expect(
        AppRole.fromStorage(null, mode: BusinessMode.team),
        AppRole.director,
      );
    });

    test('unknown value in solo mode returns masterOwner', () {
      expect(
        AppRole.fromStorage('god', mode: BusinessMode.solo),
        AppRole.masterOwner,
      );
    });

    test('director returns director', () {
      expect(AppRole.fromStorage('director'), AppRole.director);
    });

    test('masterOwner returns masterOwner', () {
      expect(AppRole.fromStorage('masterOwner'), AppRole.masterOwner);
    });

    test('master returns master', () {
      expect(AppRole.fromStorage('master'), AppRole.master);
    });
  });

  group('AppRole permissions', () {
    test('director can manage business data', () {
      expect(AppRole.director.canManageBusinessData, isTrue);
    });

    test('masterOwner can manage business data', () {
      expect(AppRole.masterOwner.canManageBusinessData, isTrue);
    });

    test('master cannot manage business data', () {
      expect(AppRole.master.canManageBusinessData, isFalse);
    });

    test('all roles can manage orders and clients', () {
      for (final role in AppRole.values) {
        expect(
          role.canManageOrdersAndClients,
          isTrue,
          reason: '${role.name} should be able to manage orders and clients',
        );
      }
    });
  });

  // ────────────────────────────────────────────────────────
  // BusinessMode
  // ────────────────────────────────────────────────────────
  group('BusinessMode.fromStorage', () {
    test('null returns null', () {
      expect(BusinessMode.fromStorage(null), isNull);
    });

    test('empty string returns null', () {
      expect(BusinessMode.fromStorage(''), isNull);
    });

    test('solo returns solo', () {
      expect(BusinessMode.fromStorage('solo'), BusinessMode.solo);
    });

    test('team returns team', () {
      expect(BusinessMode.fromStorage('team'), BusinessMode.team);
    });

    test('unknown value returns solo (fallback)', () {
      expect(BusinessMode.fromStorage('unknown'), BusinessMode.solo);
    });
  });

  // ────────────────────────────────────────────────────────
  // OrderStatus
  // ────────────────────────────────────────────────────────
  group('OrderStatus.fromName', () {
    test('null returns scheduled', () {
      expect(OrderStatus.fromName(null), OrderStatus.scheduled);
    });

    test('unknown value returns scheduled', () {
      expect(OrderStatus.fromName('cancelled'), OrderStatus.scheduled);
    });

    test('completed returns completed', () {
      expect(OrderStatus.fromName('completed'), OrderStatus.completed);
    });

    test('all values survive round-trip', () {
      for (final status in OrderStatus.values) {
        expect(OrderStatus.fromName(status.name), status);
      }
    });
  });

  // ────────────────────────────────────────────────────────
  // InventoryUnit
  // ────────────────────────────────────────────────────────
  group('InventoryUnit.fromStorage', () {
    test('null returns piece', () {
      expect(InventoryUnit.fromStorage(null), InventoryUnit.piece);
    });

    test('label "ml" returns ml', () {
      expect(InventoryUnit.fromStorage('ml'), InventoryUnit.ml);
    });

    test('name "liter" returns liter', () {
      expect(InventoryUnit.fromStorage('liter'), InventoryUnit.liter);
    });

    test('unknown returns piece', () {
      expect(InventoryUnit.fromStorage('gallon'), InventoryUnit.piece);
    });
  });
}
