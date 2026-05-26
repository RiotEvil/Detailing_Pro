import 'dart:convert';
import 'dart:io' show ContentType, HttpClient, HttpHeaders, Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'constants.dart';
import 'revenuecat_config.dart';

class RevenueCatService {
  RevenueCatService._();

  static const String _functionsRegion = 'europe-west3';
  static bool _configured = false;
  static bool _configuring = false;

  static Future<void> configureAndLogin(String? appUserId) async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform) {
      assert(() {
        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS)) {
          debugPrint(
            '[RevenueCat] DISABLED — API key is empty or invalid. '
            'Run with: flutter run --dart-define-from-file=build_config.env',
          );
        }
        return true;
      }());
      return;
    }

    final apiKey = _platformApiKey;
    if (apiKey.isEmpty) {
      return;
    }

    try {
      if (!_configured && !_configuring) {
        _configuring = true;
        try {
          if (kDebugMode) {
            await Purchases.setLogLevel(LogLevel.debug);
          }
          final config = PurchasesConfiguration(apiKey)..appUserID = appUserId;
          await Purchases.configure(config);
          _configured = true;
        } finally {
          _configuring = false;
        }
      } else if (_configuring) {
        // Another call is already initialising — skip to avoid double configure.
        return;
      } else if (appUserId != null && appUserId.isNotEmpty) {
        await Purchases.logIn(appUserId);
      }

      await refreshAndPersist();
    } catch (e) {
      debugPrint('[RevenueCat] configureAndLogin error: $e');
    }
  }

  static Future<void> refreshAndPersist() async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform || !_configured) {
      return;
    }

    try {
      final info = await Purchases.getCustomerInfo();
      await _applyCustomerInfo(info);
    } catch (e) {
      debugPrint('[RevenueCat] refreshAndPersist error: $e');
    }
  }

  static Future<void> purchasePlan(AppPlan plan) async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform || !_configured) {
      throw StateError('RevenueCat is not configured for this platform.');
    }

    final offeringId = _offeringIdForPlan(plan);
    final offerings = await Purchases.getOfferings();
    final offering = offerings.getOffering(offeringId) ?? offerings.current;
    if (offering == null || offering.availablePackages.isEmpty) {
      throw StateError('Offering "$offeringId" is missing or has no packages.');
    }

    final packageToBuy =
        offering.monthly ?? offering.annual ?? offering.availablePackages.first;
    final result = await Purchases.purchase(
      PurchaseParams.package(packageToBuy),
    );
    await _applyCustomerInfo(result.customerInfo);
  }

  static Future<void> restorePurchases() async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform || !_configured) {
      throw StateError('RevenueCat is not configured for this platform.');
    }

    final info = await Purchases.restorePurchases();
    await _applyCustomerInfo(info);
  }

  static Future<void> logOut() async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform || !_configured) {
      return;
    }

    try {
      await Purchases.logOut();
    } catch (e) {
      debugPrint('[RevenueCat] logOut error: $e');
    }
  }

  static String get _platformApiKey {
    if (kIsWeb) {
      return '';
    }
    if (Platform.isAndroid) {
      return RevenueCatConfig.androidApiKey;
    }
    if (Platform.isIOS) {
      return RevenueCatConfig.iosApiKey;
    }
    return '';
  }

  static String _offeringIdForPlan(AppPlan plan) {
    switch (plan) {
      case AppPlan.free:
        return '';
      case AppPlan.pro:
        return RevenueCatConfig.proOfferingId;
      case AppPlan.business:
        return RevenueCatConfig.businessOfferingId;
    }
  }

  static Future<void> _applyCustomerInfo(CustomerInfo info) async {
    final box = Hive.box(HiveBoxes.settings);
    final activeEntitlements = info.entitlements.active;

    final businessEntitlement =
        activeEntitlements[RevenueCatConfig.businessEntitlementId];
    final proEntitlement =
        activeEntitlements[RevenueCatConfig.proEntitlementId];

    AppPlan plan = AppPlan.free;
    var status = PlanStatus.inactive;

    if (businessEntitlement != null) {
      plan = AppPlan.business;
      status = _derivePlanStatus(businessEntitlement);
    } else if (proEntitlement != null) {
      plan = AppPlan.pro;
      status = _derivePlanStatus(proEntitlement);
    }

    await box.put('appPlan', plan.name);
    await box.put('planStatus', status.name);
    await box.put('billingProvider', 'revenuecat');

    if (status == PlanStatus.trial) {
      final entitlement = businessEntitlement ?? proEntitlement;
      try {
        final expStr = entitlement?.expirationDate?.toString();
        if (expStr != null) {
          final expDate = DateTime.tryParse(expStr);
          if (expDate != null) {
            await box.put('trialEndsAt', expDate.millisecondsSinceEpoch);
          }
        }
      } catch (e) {
        debugPrint('[RevenueCat] could not parse trialEndsAt: $e');
      }
    } else {
      await box.delete('trialEndsAt');
    }

    await _syncPlanWithBackend();
  }

  static Future<void> _syncPlanWithBackend() async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final projectId = Firebase.app().options.projectId;
    if (projectId.isEmpty) {
      return;
    }

    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      return;
    }

    final uri = Uri.parse(
      'https://$_functionsRegion-$projectId.cloudfunctions.net/syncPlanStatus',
    );
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 10);

    try {
      final request = await client
          .postUrl(uri)
          .timeout(const Duration(seconds: 10));
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $idToken');
      request.headers.contentType = ContentType.json;
      request.add(utf8.encode('{}'));

      final response = await request
          .close()
          .timeout(const Duration(seconds: 10));
      final body = await utf8.decoder
          .bind(response)
          .join()
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 429) {
        return;
      }

      if (response.statusCode != 200) {
        debugPrint(
          '[RevenueCat] syncPlanWithBackend failed: ${response.statusCode} $body',
        );
        return;
      }

      final payload = jsonDecode(body);
      if (payload is! Map<String, dynamic>) {
        return;
      }

      final remotePlan = payload['plan']?.toString();
      final remoteStatus = payload['planStatus']?.toString();
      final remoteProvider = payload['billingProvider']?.toString();
      final box = Hive.box(HiveBoxes.settings);

      if (remotePlan != null && remotePlan.isNotEmpty) {
        await box.put('appPlan', remotePlan);
      }
      if (remoteStatus != null && remoteStatus.isNotEmpty) {
        await box.put('planStatus', remoteStatus);
      }
      if (remoteProvider != null && remoteProvider.isNotEmpty) {
        await box.put('billingProvider', remoteProvider);
      }
    } catch (e) {
      debugPrint('[RevenueCat] syncPlanWithBackend error: $e');
    } finally {
      client.close(force: true);
    }
  }

  static PlanStatus _derivePlanStatus(dynamic entitlement) {
    try {
      final dynamic periodType = entitlement.periodType;
      final periodTypeName = periodType == null
          ? ''
          : (periodType.name?.toString() ?? periodType.toString());
      if (periodTypeName.toLowerCase().contains('trial')) {
        return PlanStatus.trial;
      }
    } catch (e) {
      debugPrint('Error deriving plan status from periodType: $e');
    }

    try {
      final dynamic billingIssueDetectedAt = entitlement.billingIssueDetectedAt;
      if (billingIssueDetectedAt != null) {
        return PlanStatus.grace;
      }
    } catch (e) {
      debugPrint('Error deriving plan status from billingIssue: $e');
    }

    return PlanStatus.active;
  }
}
