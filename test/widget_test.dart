import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/core/constants.dart';
import 'package:flutter_application_1/core/onboarding_prefs.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hive_widget_');
    Hive.init(dir.path);

    await Hive.openBox(HiveBoxes.clients);
    await Hive.openBox(HiveBoxes.services);
    await Hive.openBox(HiveBoxes.orders);
    await Hive.openBox(HiveBoxes.inventory);
    await Hive.openBox(HiveBoxes.settings);

    final settings = Hive.box(HiveBoxes.settings);
    await settings.put('locale', 'en');
    await settings.put('currency', '€');
    await OnboardingPrefs.markPreAuthCompleted(settings, skipped: true);
  });

  tearDown(() async {
    await Hive.box(HiveBoxes.orders).clear();
    await Hive.box(HiveBoxes.clients).clear();
    await Hive.box(HiveBoxes.services).clear();
    await Hive.box(HiveBoxes.inventory).clear();
  });

  tearDownAll(() async {
    await Future.any([
      Hive.close(),
      Future.delayed(const Duration(seconds: 5)),
    ]);
  });

  testWidgets('App starts and shows auth screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DetailingProApp(locale: Locale('en')));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byIcon(Icons.g_mobiledata), findsOneWidget);
  });
}
