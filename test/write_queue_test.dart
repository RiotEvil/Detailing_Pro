import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_application_1/core/constants.dart';
import 'package:flutter_application_1/core/write_queue.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hive_write_queue_');
    Hive.init(dir.path);
    await Hive.openBox(HiveBoxes.pendingWrites);
  });

  tearDown(() async {
    await Hive.box(HiveBoxes.pendingWrites).clear();
    WriteQueue.pendingCountNotifier.value = 0;
    WriteQueue.failedCountNotifier.value = 0;
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('enqueueSet increases pending count', () async {
    await WriteQueue.enqueueSet(
      orgId: 'org_test',
      collection: 'clients',
      docId: 'client_1',
      data: {'id': 'client_1', 'name': 'Alice'},
    );

    expect(WriteQueue.pendingCount, 1);
    expect(WriteQueue.failedCount, 0);
  });

  test('discardFailed clears dead-letter entries', () async {
    final box = Hive.box(HiveBoxes.pendingWrites);
    await box.put('dead::clients_client_3', {
      'op': 'set',
      'orgId': 'org_test',
      'collection': 'clients',
      'docId': 'client_3',
      'failedAt': DateTime.now().millisecondsSinceEpoch,
    });
    WriteQueue.failedCountNotifier.value = WriteQueue.failedCount;

    expect(WriteQueue.failedCount, 1);
    await WriteQueue.discardFailed();
    expect(WriteQueue.failedCount, 0);
  });
}
