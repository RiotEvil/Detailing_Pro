import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

/// Centralised wrapper for Firebase Analytics.
/// All event names use snake_case to match GA4 convention.
class AnalyticsService {
  AnalyticsService._();

  static FirebaseAnalytics? get _fa {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAnalytics.instance;
  }

  // ── Auth ──────────────────────────────────────────────────────────────────

  static Future<void> logLogin({required String method}) async {
    try {
      await _fa?.logLogin(loginMethod: method);
    } catch (e) {
      _log(e);
    }
  }

  static Future<void> logSignUp({required String method}) async {
    try {
      await _fa?.logSignUp(signUpMethod: method);
    } catch (e) {
      _log(e);
    }
  }

  static Future<void> logLogout() async {
    try {
      await _fa?.logEvent(name: 'logout');
    } catch (e) {
      _log(e);
    }
  }

  // ── Orders ────────────────────────────────────────────────────────────────

  static Future<void> logOrderCreated({required double price}) async {
    try {
      await _fa?.logEvent(name: 'order_created', parameters: {'price': price});
    } catch (e) { _log(e); }
  }

  static Future<void> logOrderStatusChanged({required String status}) async {
    try {
      await _fa?.logEvent(
        name: 'order_status_changed',
        parameters: {'status': status},
      );
    } catch (e) { _log(e); }
  }

  // ── Clients ───────────────────────────────────────────────────────────────

  static Future<void> logClientCreated() async {
    try {
      await _fa?.logEvent(name: 'client_created');
    } catch (e) {
      _log(e);
    }
  }

  // ── Subscriptions ─────────────────────────────────────────────────────────

  static Future<void> logPlanUpgrade({
    required String plan,
    required double revenue,
  }) async {
    try {
      await _fa?.logPurchase(
        currency: 'EUR',
        value: revenue,
        items: [AnalyticsEventItem(itemName: plan, itemId: plan)],
      );
    } catch (e) { _log(e); }
  }

  static Future<void> logPricingScreenOpened() async {
    try {
      await _fa?.logEvent(name: 'pricing_screen_opened');
    } catch (e) {
      _log(e);
    }
  }

  // ── Online booking ────────────────────────────────────────────────────────

  static Future<void> logBookingRequestReceived() async {
    try {
      await _fa?.logEvent(name: 'booking_request_received');
    } catch (e) {
      _log(e);
    }
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  static Future<void> logLanguageChanged({required String locale}) async {
    try {
      await _fa?.logEvent(
        name: 'language_changed',
        parameters: {'locale': locale},
      );
    } catch (e) { _log(e); }
  }

  // ── User properties ───────────────────────────────────────────────────────

  static Future<void> setPlan(String plan) async {
    try {
      await _fa?.setUserProperty(name: 'plan', value: plan);
    } catch (e) {
      _log(e);
    }
  }

  static Future<void> setBusinessMode(String mode) async {
    try {
      await _fa?.setUserProperty(name: 'business_mode', value: mode);
    } catch (e) {
      _log(e);
    }
  }

  // ── Navigator observer ────────────────────────────────────────────────────

  static List<NavigatorObserver> get navigatorObservers {
    final analytics = _fa;
    if (analytics == null) return const [];
    return [FirebaseAnalyticsObserver(analytics: analytics)];
  }

  static void _log(Object e) => debugPrint('[Analytics] error: $e');
}
