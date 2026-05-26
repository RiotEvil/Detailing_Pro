import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';

class AppColors {
  AppColors._();
  static const Color primary = Colors.orangeAccent;
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color card = Color(0xFF1E1E1E);
  static const Color success = Colors.green;
  static const Color warning = Colors.amber;
  static const Color error = Colors.redAccent;
  static const Color info = Colors.blueAccent;
  static const Color textSecondary = Colors.grey;
}

enum OrderStatus {
  scheduled('Scheduled'),
  inProgress('In progress'),
  ready('Ready'),
  paid('Paid'),
  completed('Completed');

  final String label;
  const OrderStatus(this.label);

  Color get color {
    switch (this) {
      case OrderStatus.scheduled:
        return AppColors.info;
      case OrderStatus.inProgress:
        return AppColors.warning;
      case OrderStatus.ready:
        return AppColors.success;
      case OrderStatus.paid:
        return Colors.teal;
      case OrderStatus.completed:
        return AppColors.textSecondary;
    }
  }

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case OrderStatus.scheduled:
        return l10n.statusScheduled;
      case OrderStatus.inProgress:
        return l10n.statusInProgress;
      case OrderStatus.ready:
        return l10n.statusReady;
      case OrderStatus.paid:
        return l10n.statusPaid;
      case OrderStatus.completed:
        return l10n.statusCompleted;
    }
  }

  static OrderStatus fromName(String? name) {
    if (name == null || name.isEmpty) return OrderStatus.scheduled;
    return OrderStatus.values.firstWhere(
      (e) => e.name == name,
      orElse: () {
        assert(false, 'Unknown OrderStatus "$name" — defaulting to scheduled');
        return OrderStatus.scheduled;
      },
    );
  }
}

class AppStrings {
  AppStrings._();
  static const String statusScheduled = 'Scheduled';
  static const String statusInProgress = 'In progress';
  static const String statusReady = 'Ready';
  static const String statusPaid = 'Paid';
  static const String statusCompleted = 'Completed';
}

class HiveBoxes {
  HiveBoxes._();
  static const String inventory = 'inventoryBox';
  static const String services = 'servicesBox';
  static const String orders = 'ordersBox';
  static const String settings = 'settingsBox';
  static const String clients = 'clientsBox';
  static const String vehicles = 'vehiclesBox';
  static const String packages = 'packagesBox';
  static const String photos = 'photosBox';
  static const String finance = 'financeBox';
  static const String marketing = 'marketingBox';
  static const String pendingWrites = 'pendingWritesBox';
}

enum BusinessMode {
  solo,
  team;

  static BusinessMode? fromStorage(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return BusinessMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => BusinessMode.solo,
    );
  }
}

enum AppRole {
  director,
  masterOwner,
  master;

  static AppRole fromStorage(String? value, {BusinessMode? mode}) {
    if (value == null || value.isEmpty) {
      return mode == BusinessMode.team ? AppRole.director : AppRole.masterOwner;
    }

    return AppRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () =>
          mode == BusinessMode.team ? AppRole.director : AppRole.masterOwner,
    );
  }

  String get label {
    switch (this) {
      case AppRole.director:
        return 'Director';
      case AppRole.masterOwner:
        return 'Owner specialist';
      case AppRole.master:
        return 'Specialist';
    }
  }

  bool get canManageBusinessData {
    return this == AppRole.director || this == AppRole.masterOwner;
  }

  bool get canManageOrdersAndClients {
    return this == AppRole.director ||
        this == AppRole.masterOwner ||
        this == AppRole.master;
  }
}

enum AppPlan {
  free,
  pro,
  business;

  static AppPlan fromStorage(String? value) {
    if (value == null || value.isEmpty) {
      return AppPlan.free;
    }

    return AppPlan.values.firstWhere(
      (plan) => plan.name == value,
      orElse: () => AppPlan.free,
    );
  }

  String get label {
    switch (this) {
      case AppPlan.free:
        return 'Free';
      case AppPlan.pro:
        return 'Pro';
      case AppPlan.business:
        return 'Business';
    }
  }
}

enum PlanStatus {
  inactive,
  active,
  trial,
  grace;

  static PlanStatus fromStorage(String? value) {
    if (value == null || value.isEmpty) {
      return PlanStatus.inactive;
    }

    return PlanStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => PlanStatus.inactive,
    );
  }

  bool get grantsAccess {
    return this == PlanStatus.active ||
        this == PlanStatus.trial ||
        this == PlanStatus.grace;
  }

  String get label {
    switch (this) {
      case PlanStatus.inactive:
        return 'Inactive';
      case PlanStatus.active:
        return 'Active';
      case PlanStatus.trial:
        return 'Trial';
      case PlanStatus.grace:
        return 'Grace period';
    }
  }
}

enum InventoryItemType {
  chemistry,
  consumable,
  accessory,
  equipment;

  static InventoryItemType fromStorage(String? value) {
    if (value == null || value.isEmpty) {
      return InventoryItemType.chemistry;
    }

    return InventoryItemType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => InventoryItemType.chemistry,
    );
  }

  String get label {
    switch (this) {
      case InventoryItemType.chemistry:
        return 'Chemistry';
      case InventoryItemType.consumable:
        return 'Consumable';
      case InventoryItemType.accessory:
        return 'Accessory';
      case InventoryItemType.equipment:
        return 'Equipment';
    }
  }

  IconData get icon {
    switch (this) {
      case InventoryItemType.chemistry:
        return Icons.science;
      case InventoryItemType.consumable:
        return Icons.inventory_2_outlined;
      case InventoryItemType.accessory:
        return Icons.cleaning_services_outlined;
      case InventoryItemType.equipment:
        return Icons.precision_manufacturing_outlined;
    }
  }

  InventoryUnit get defaultUnit {
    switch (this) {
      case InventoryItemType.chemistry:
        return InventoryUnit.ml;
      case InventoryItemType.consumable:
        return InventoryUnit.piece;
      case InventoryItemType.accessory:
        return InventoryUnit.piece;
      case InventoryItemType.equipment:
        return InventoryUnit.piece;
    }
  }
}

enum InventoryUnit {
  ml,
  liter,
  piece,
  set,
  meter,
  kilogram;

  String get label {
    switch (this) {
      case InventoryUnit.ml:
        return 'ml';
      case InventoryUnit.liter:
        return 'l';
      case InventoryUnit.piece:
        return 'pcs';
      case InventoryUnit.set:
        return 'set';
      case InventoryUnit.meter:
        return 'm';
      case InventoryUnit.kilogram:
        return 'kg';
    }
  }

  static InventoryUnit fromStorage(String? value) {
    if (value == null || value.isEmpty) {
      return InventoryUnit.piece;
    }

    return InventoryUnit.values.firstWhere(
      (unit) => unit.label == value || unit.name == value,
      orElse: () => InventoryUnit.piece,
    );
  }
}
