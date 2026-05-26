import 'package:flutter/foundation.dart';

class RevenueCatConfig {
  RevenueCatConfig._();

  // Provide keys via --dart-define in CI/CD or local build command.
  static const String _androidApiKeyEnv = String.fromEnvironment(
    'RC_ANDROID_API_KEY',
    defaultValue: '',
  );
  static const String _iosApiKeyEnv = String.fromEnvironment(
    'RC_IOS_API_KEY',
    defaultValue: '',
  );

  static String get androidApiKey => _androidApiKeyEnv.trim();
  static String get iosApiKey => _iosApiKeyEnv.trim();

  // Entitlement identifiers in RevenueCat.
  static const String proEntitlementId = 'pro';
  static const String businessEntitlementId = 'business';

  // Optional offering identifiers in RevenueCat. Override via dart-define if needed.
  static const String proOfferingId = String.fromEnvironment(
    'RC_PRO_OFFERING_ID',
    defaultValue: 'pro',
  );
  static const String businessOfferingId = String.fromEnvironment(
    'RC_BUSINESS_OFFERING_ID',
    defaultValue: 'business',
  );

  static bool get isEnabledForCurrentPlatform {
    if (kIsWeb) {
      return false;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _isValidPublicSdkKey(androidApiKey);
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _isValidPublicSdkKey(iosApiKey);
    }
    return false;
  }

  static bool _isValidPublicSdkKey(String key) {
    return (key.startsWith('appl_') && key.length > 'appl_'.length) ||
        (key.startsWith('goog_') && key.length > 'goog_'.length);
  }
}
