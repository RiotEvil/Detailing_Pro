import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_application_1/core/app_data_service.dart';
import 'package:flutter_application_1/core/constants.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hive_app_data_');
    Hive.init(dir.path);
    await Hive.openBox(HiveBoxes.orders);
    await Hive.openBox(HiveBoxes.settings);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('AppDataService (no Firebase)', () {
    // syncOrderToCloud writes to Firestore, not directly to Hive.
    // Without Firebase, it should return gracefully without throwing.
    test('syncOrderToCloud does not throw when Firebase is not initialized',
        () async {
      final order = {'id': 'test_order', 'clientName': 'Test Client'};
      await expectLater(
        AppDataService.syncOrderToCloud(order),
        completes,
      );
    });

    test('syncOrderToCloud with empty id does not throw', () async {
      final order = {'id': '', 'clientName': 'Test Client'};
      await expectLater(
        AppDataService.syncOrderToCloud(order),
        completes,
      );
    });

    test('deleteOrderFromCloud does not throw when Firebase is not initialized',
        () async {
      await expectLater(
        AppDataService.deleteOrderFromCloud('some_id'),
        completes,
      );
    });

    test('deleteOrderFromCloud with null id does not throw', () async {
      await expectLater(
        AppDataService.deleteOrderFromCloud(null),
        completes,
      );
    });

    test('stopCloudSync does not throw when not syncing', () async {
      await expectLater(AppDataService.stopCloudSync(), completes);
    });

    test('startCloudSync does not throw when Firebase is not initialized',
        () async {
      await expectLater(AppDataService.startCloudSync(), completes);
    });
  });
}
