import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants.dart';
import 'onboarding_prefs.dart';

// Boxes that contain personal or sensitive data and must be encrypted.

const _secureStorageKey = 'hive_aes_key_v1';

final _secureStorage = const FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

/// Thrown when encrypted Hive boxes cannot be opened or migrated.
class HiveStartupException implements Exception {
  final String message;
  final Object? cause;

  HiveStartupException(this.message, [this.cause]);

  @override
  String toString() =>
      cause == null ? message : '$message ($cause)';
}

/// Инициализация всех хранилищ Hive
Future<void> setupHiveBoxes() async {
  try {
    final cipher = await _getOrCreateCipher();

    // Open sensitive boxes with AES encryption, plain boxes without.
    await Future.wait([
      _openBoxEncrypted(HiveBoxes.inventory, cipher),
      _openBoxEncrypted(HiveBoxes.services, cipher),
      _openBoxEncrypted(HiveBoxes.packages, cipher),
      _openBoxEncrypted(HiveBoxes.photos, cipher),
      _openBoxEncrypted(HiveBoxes.marketing, cipher),
      _openBoxEncrypted(HiveBoxes.settings, cipher),
      _openBoxEncrypted(HiveBoxes.clients, cipher),
      _openBoxEncrypted(HiveBoxes.orders, cipher),
      _openBoxEncrypted(HiveBoxes.finance, cipher),
      _openBoxEncrypted(HiveBoxes.vehicles, cipher),
      _openBoxEncrypted(HiveBoxes.pendingWrites, cipher),
    ]);

    // Заполняем базу начальными данными, если она пуста
    await _seedInitialData();
  } catch (e, stack) {
    debugPrint('Critical Hive setup error: $e');
    debugPrint(stack.toString());
    Error.throwWithStackTrace(
      HiveStartupException('Failed to initialize local storage', e),
      stack,
    );
  }
}

/// Returns an AES cipher backed by a key stored in the OS secure keystore.
/// On first run a random 32-byte key is generated and persisted.
Future<HiveAesCipher> _getOrCreateCipher() async {
  String? b64;
  try {
    b64 = await _secureStorage.read(key: _secureStorageKey);
  } on PlatformException {
    // Android Keystore or EncryptedSharedPreferences lost access to the key
    // (can happen after certain system security events or backup/restore).
    // Boxes encrypted with the lost key are unrecoverable — nuke them.
    // Cloud data is safe and will resync after the user signs in.
    try { await _secureStorage.deleteAll(); } catch (_) {}
    await _nukeAllHiveBoxFiles();
    // b64 remains null → fresh key generated below.
  }
  if (b64 == null) {
    final key = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    b64 = base64UrlEncode(key);
    await _secureStorage.write(key: _secureStorageKey, value: b64);
  }
  return HiveAesCipher(base64Url.decode(b64));
}

/// Deletes all Hive box files from disk. Used when the encryption key is lost.
Future<void> _nukeAllHiveBoxFiles() async {
  const names = [
    HiveBoxes.inventory, HiveBoxes.services, HiveBoxes.packages,
    HiveBoxes.photos, HiveBoxes.marketing, HiveBoxes.settings,
    HiveBoxes.clients, HiveBoxes.orders, HiveBoxes.finance,
    HiveBoxes.vehicles, HiveBoxes.pendingWrites,
  ];
  for (final name in names) {
    try {
      if (Hive.isBoxOpen(name)) await Hive.box(name).close();
      await Hive.deleteBoxFromDisk(name);
    } catch (_) {}
  }
}

/// Opens a box with AES encryption.
/// If the box already exists as unencrypted (legacy install), migrates all
/// data to a fresh encrypted box transparently.
Future<Box<T>> _openBoxEncrypted<T>(String name, HiveAesCipher cipher) async {
  if (Hive.isBoxOpen(name)) return Hive.box<T>(name);

  try {
    return await Hive.openBox<T>(name, encryptionCipher: cipher);
  } catch (e) {
    // Only treat HiveErrors as a legacy-unencrypted-box migration case.
    // Any other exception (I/O, permissions, disk full) must propagate.
    if (e is! HiveError) rethrow;
    // Box exists but is unencrypted — migrate to encrypted storage.
    debugPrint('[Hive] Migrating "$name" to encrypted storage …');
    final plain = await Hive.openBox<T>(name);
    final snapshot = {for (final k in plain.keys) k: plain.get(k)};
    await plain.close();
    await Hive.deleteBoxFromDisk(name);
    final encrypted = await Hive.openBox<T>(name, encryptionCipher: cipher);
    for (final entry in snapshot.entries) {
      if (entry.value != null) await encrypted.put(entry.key, entry.value as T);
    }
    debugPrint(
      '[Hive] Migration of "$name" complete (${snapshot.length} records).',
    );
    return encrypted;
  }
}


/// Агрегатор функций наполнения данными
Future<void> _seedInitialData() async {
  await _seedInventory();
  await _seedServices();
  await _seedSettings();
  await _migrateOnboardingDefaults();
  await _migrateInternationalDefaults();
  await _migratePlanDefaults();
  await _migrateInventorySchema();
  await _migrateClientIds();
  await _migrateOrderClientRefs();
}

Future<void> _seedInventory() async {
  final box = Hive.box(HiveBoxes.inventory);
  if (box.isNotEmpty) return;

  final List<Map<String, dynamic>> data = [
    {
      'id': 'green_star',
      'name': 'Green Star',
      'itemType': InventoryItemType.chemistry.name,
      'brand': 'Koch Chemie',
      'category': 'APC / Prewash',
      'ph': 12.5,
      'dilution': '1:5–1:30',
      'usage': 'Exterior, Engine bay, Interior textiles',
      'amount': 1000,
      'unit': 'ml',
      'minStock': 250,
    },
    {
      'id': 'gsf',
      'name': 'Gentle Snow Foam',
      'itemType': InventoryItemType.chemistry.name,
      'brand': 'Koch Chemie',
      'category': 'Foam',
      'ph': 7.0,
      'dilution': '1:10–1:20',
      'usage': 'Prewash foam, safe on coatings',
      'amount': 1000,
      'unit': 'ml',
      'minStock': 250,
    },
    {
      'id': 'tar_remover',
      'name': 'Tar & Glue Remover',
      'itemType': InventoryItemType.chemistry.name,
      'brand': 'Koch Chemie',
      'category': 'Quick Detailer',
      'ph': 9.0,
      'dilution': '1:1–1:5',
      'usage': 'Tar removal, glue spots',
      'amount': 500,
      'unit': 'ml',
      'minStock': 150,
    },
    {
      'id': 'wax',
      'name': 'Premium Wax',
      'itemType': InventoryItemType.chemistry.name,
      'brand': 'Meguiar\'s',
      'category': 'Wax/Sealant',
      'ph': 7.0,
      'dilution': 'Ready to use',
      'usage': 'Paint protection, gloss enhancement',
      'amount': 500,
      'unit': 'ml',
      'minStock': 150,
    },
    {
      'id': 'interior_cleaner',
      'name': 'Interior Cleaner',
      'itemType': InventoryItemType.chemistry.name,
      'brand': 'Chemical Guys',
      'category': 'Interior',
      'ph': 8.0,
      'dilution': '1:10',
      'usage': 'Dashboard, plastics, fabrics',
      'amount': 750,
      'unit': 'ml',
      'minStock': 200,
    },
    {
      'id': 'microfiber_towels',
      'name': 'Microfiber Towel 40x40',
      'itemType': InventoryItemType.consumable.name,
      'brand': 'Work Stuff',
      'category': 'Textile',
      'usage': 'Final wipe, interior, glass',
      'amount': 24,
      'unit': 'pcs',
      'minStock': 8,
      'location': 'Shelf A1',
    },
    {
      'id': 'nitrile_gloves',
      'name': 'Nitrile Gloves',
      'itemType': InventoryItemType.consumable.name,
      'brand': 'Benovy',
      'category': 'Protection',
      'usage': 'Work with chemicals and interior',
      'amount': 6,
      'unit': 'set',
      'minStock': 2,
      'location': 'Consumables cabinet',
    },
    {
      'id': 'masking_tape',
      'name': 'Masking Tape 3M',
      'itemType': InventoryItemType.accessory.name,
      'brand': '3M',
      'category': 'Polishing',
      'usage': 'Masking plastic and edges',
      'amount': 10,
      'unit': 'pcs',
      'minStock': 3,
      'location': 'Polishing shelf',
    },
    {
      'id': 'polishing_pad',
      'name': 'Polishing Pad 125 mm',
      'itemType': InventoryItemType.accessory.name,
      'brand': 'Lake Country',
      'category': 'Polishing',
      'usage': 'Medium abrasive level',
      'amount': 12,
      'unit': 'pcs',
      'minStock': 4,
      'location': 'Polishing shelf',
    },
    {
      'id': 'steam_machine',
      'name': 'Steam Cleaner',
      'itemType': InventoryItemType.equipment.name,
      'brand': 'Karcher',
      'category': 'Equipment',
      'usage': 'Interior cleaning and hard-to-reach areas',
      'amount': 1,
      'unit': 'pcs',
      'minStock': 1,
      'location': 'Equipment zone',
    },
  ];

  // Используем putAt или put(id, data) для контроля ключей,
  // но для сидинга addAll тоже подходит
  await box.addAll(data);
}

Future<void> _migrateInventorySchema() async {
  final box = Hive.box(HiveBoxes.inventory);

  for (final key in box.keys) {
    final raw = box.get(key);
    if (raw is! Map) continue;

    final item = Map<String, dynamic>.from(raw);
    var changed = false;

    if ((item['itemType']?.toString() ?? '').isEmpty) {
      item['itemType'] = InventoryItemType.chemistry.name;
      changed = true;
    }

    if ((item['unit']?.toString() ?? '').isEmpty) {
      item['unit'] = InventoryUnit.ml.label;
      changed = true;
    }

    if (item['minStock'] == null) {
      final unit = InventoryUnit.fromStorage(item['unit']?.toString());
      item['minStock'] = unit == InventoryUnit.ml ? 200 : 3;
      changed = true;
    }

    if (changed) {
      await box.put(key, item);
    }
  }
}

Future<void> _seedServices() async {
  final box = Hive.box(HiveBoxes.services);
  if (box.isNotEmpty) return;

  final List<Map<String, dynamic>> data = [
    {
      'name': 'Detailing Exterior Wash',
      'price': 50.0,
      'duration': 30,
      'chemistry': ['green_star'],
      'chemAmount': 100,
    },
    {
      'name': 'Active Foam',
      'price': 30.0,
      'duration': 20,
      'chemistry': ['gsf'],
      'chemAmount': 50,
    },
    {
      'name': 'Tar and Glue Removal',
      'price': 40.0,
      'duration': 15,
      'chemistry': ['tar_remover'],
      'chemAmount': 50,
    },
    {
      'name': 'Wax Application',
      'price': 60.0,
      'duration': 45,
      'chemistry': ['wax'],
      'chemAmount': 100,
    },
    {
      'name': 'Interior Cleaning',
      'price': 35.0,
      'duration': 25,
      'chemistry': ['interior_cleaner'],
      'chemAmount': 75,
    },
  ];

  await box.addAll(data);
}

Future<void> _seedSettings() async {
  final box = Hive.box(HiveBoxes.settings);
  if (box.isNotEmpty) return;

  // Начальные настройки
  await box.put('currency', '€');
  await box.put('locale', 'en');
  await box.put('language', 'en');
  await box.put('theme', 'dark');
  await box.put('appPlan', AppPlan.free.name);
  await box.put('planStatus', PlanStatus.inactive.name);
  await box.put('billingProvider', 'manual');
}

Future<void> _migrateInternationalDefaults() async {
  final box = Hive.box(HiveBoxes.settings);
  final migrated = box.get('intlDefaultsMigratedV1', defaultValue: false);
  if (migrated == true) {
    return;
  }

  final locale = box.get('locale')?.toString();
  final language = box.get('language')?.toString();
  final currency = box.get('currency')?.toString();

  final hasLegacyRussianDefaults =
      (locale == null || locale == 'ru') &&
      (language == null || language == 'ru') &&
      (currency == null || currency == '₽');

  if (hasLegacyRussianDefaults) {
    await box.put('locale', 'en');
    await box.put('language', 'en');
    await box.put('currency', '€');
  }

  await box.put('intlDefaultsMigratedV1', true);
}

Future<void> _migratePlanDefaults() async {
  final box = Hive.box(HiveBoxes.settings);
  if (box.get('appPlan') == null) {
    await box.put('appPlan', AppPlan.free.name);
  }
  if (box.get('planStatus') == null) {
    await box.put('planStatus', PlanStatus.inactive.name);
  }
  if (box.get('billingProvider') == null) {
    await box.put('billingProvider', 'manual');
  }
}

Future<void> _migrateOnboardingDefaults() async {
  final box = Hive.box(HiveBoxes.settings);
  await OnboardingPrefs.ensureDefaults(box);
}

Future<void> _migrateClientIds() async {
  final clientsBox = Hive.box(HiveBoxes.clients);

  for (final key in clientsBox.keys) {
    final raw = clientsBox.get(key);
    if (raw is! Map) continue;

    final map = Map<String, dynamic>.from(raw);
    final currentId = map['id']?.toString();
    if (currentId == null || currentId.isEmpty) {
      map['id'] = 'client_${key.toString()}';
      await clientsBox.put(key, map);
    }
  }
}

Future<void> _migrateOrderClientRefs() async {
  final clientsBox = Hive.box(HiveBoxes.clients);
  final ordersBox = Hive.box(HiveBoxes.orders);

  final Map<String, String> clientIdByName = {};
  for (final raw in clientsBox.values) {
    if (raw is! Map) continue;
    final name = raw['name']?.toString();
    final id = raw['id']?.toString();
    if (name == null || name.isEmpty || id == null || id.isEmpty) continue;
    clientIdByName.putIfAbsent(name, () => id);
  }

  for (final key in ordersBox.keys) {
    final raw = ordersBox.get(key);
    if (raw is! Map) continue;

    final map = Map<String, dynamic>.from(raw);
    final currentClientId = map['clientId']?.toString();
    if (currentClientId != null && currentClientId.isNotEmpty) continue;

    final clientName = map['client']?.toString();
    if (clientName == null || clientName.isEmpty) continue;

    final resolvedClientId = clientIdByName[clientName];
    if (resolvedClientId == null) continue;

    map['clientId'] = resolvedClientId;
    await ordersBox.put(key, map);
  }
}
