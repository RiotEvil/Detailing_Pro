import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'firebase_options.dart';
import 'core/app_data_service.dart';
import 'core/constants.dart';
import 'core/cloud_profile_sync.dart';
import 'core/force_update_service.dart';
import 'core/hive_setup.dart';
import 'core/network_sync_listener.dart';
import 'core/notification_center.dart';
import 'core/online_booking_service.dart';
import 'core/onboarding_prefs.dart';
import 'core/order_reminder_service.dart';
import 'core/analytics_service.dart';
import 'core/revenuecat_service.dart';
import 'core/theme.dart';
import 'core/write_queue.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application_1/screens/main_navigation_screen.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';
import 'package:flutter_application_1/screens/business_mode_screen.dart';
import 'package:flutter_application_1/screens/onboarding/first_run_onboarding_screen.dart';
import 'package:flutter_application_1/widgets/storage_startup_error_app.dart';

/// FCM background message handler — must be a top-level function.
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] Background message: ${message.notification?.title}');
}

void main() async {
  // 1. Обязательная привязка Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Disable debug prints in release builds
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  Object? storageStartupFailure;
  StackTrace? storageStartupStack;

  try {
    // 2. Инициализация Hive
    await Hive.initFlutter();

    // 3. Открываем все боксы и выполняем стартовый сидинг
    await setupHiveBoxes();

    // 4. Форматирование дат (независимо от уведомлений)
    await initializeDateFormatting();

    await NetworkSyncListener.start();
    WriteQueue.pendingCountNotifier.value = WriteQueue.pendingCount;
    WriteQueue.failedCountNotifier.value = WriteQueue.failedCount;
  } catch (e, stack) {
    storageStartupFailure = e;
    storageStartupStack = stack;
    debugPrint('APP STARTUP ERROR: $e');
  }

  // Notifications are non-critical — failure must not block app startup.
  try {
    await _setupNotifications();
  } catch (e) {
    debugPrint('Notification setup failed (non-fatal): $e');
  }

  // Firebase optional at local dev stage.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      !kDebugMode,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    if (storageStartupFailure != null) {
      await FirebaseCrashlytics.instance.recordError(
        storageStartupFailure,
        storageStartupStack,
        fatal: true,
        reason: 'hive_startup_failed',
      );
    }
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
    // Register FCM background handler
    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    // Show local notification for foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final n = message.notification;
      if (n == null) return;
      appNotifications.show(
        message.hashCode,
        n.title ?? 'Notification',
        n.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'push_channel',
            'Push notifications',
            channelDescription: 'Cloud push notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'ic_launcher_foreground',
          ),
        ),
      );
    });
  } catch (e) {
    debugPrint('Firebase is not initialized: $e');
  }

  if (storageStartupFailure != null) {
    runApp(
      StorageStartupErrorApp(
        message: storageStartupFailure.toString(),
      ),
    );
    return;
  }

  runApp(const DetailingProApp());
}

/// Настройка уведомлений, чтобы не загромождать main
Future<void> _setupNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher_foreground');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await appNotifications.initialize(initializationSettings);

  await appNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  await OrderReminderService.ensureInitialized();
}

class DetailingProApp extends StatefulWidget {
  final Locale? locale;

  const DetailingProApp({super.key, this.locale});

  @override
  State<DetailingProApp> createState() => _DetailingProAppState();
}

class _DetailingProAppState extends State<DetailingProApp> {
  late final Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box(HiveBoxes.settings);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _settingsBox.listenable(keys: ['locale']),
      builder: (context, Box box, _) {
        final localeCode = box.get('locale') as String?;
        final locale = localeCode != null ? Locale(localeCode) : widget.locale;

        return MaterialApp(
          locale: locale,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          navigatorObservers: AnalyticsService.navigatorObservers,
          home: const AuthGate(),
        );
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  late final Box _settingsBox;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<Map<String, String>>? _accessProfileSubscription;
  StreamSubscription<String>? _fcmTokenRefreshSub;
  int _lastFailedWriteCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _settingsBox = Hive.box(HiveBoxes.settings);
    OnboardingPrefs.ensureDefaults(_settingsBox);
    _hydrateAccessProfileFromCloud();
    _bindAuthAndAccessWatchers();
    _requestFcmPermission();
    _checkForUpdate();
    AppDataService.hasSyncError.addListener(_onSyncErrorChanged);
    WriteQueue.failedCountNotifier.addListener(_onFailedWritesChanged);
    _lastFailedWriteCount = WriteQueue.failedCount;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppDataService.hasSyncError.removeListener(_onSyncErrorChanged);
    WriteQueue.failedCountNotifier.removeListener(_onFailedWritesChanged);
    _authSubscription?.cancel();
    _accessProfileSubscription?.cancel();
    _fcmTokenRefreshSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(WriteQueue.flush());
      _hydrateAccessProfileFromCloud();
    }
  }

  void _onFailedWritesChanged() {
    if (!mounted) return;
    final failed = WriteQueue.failedCount;
    if (failed <= _lastFailedWriteCount) {
      _lastFailedWriteCount = failed;
      return;
    }
    _lastFailedWriteCount = failed;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n?.settingsSyncFailedMessage(failed) ??
              '$failed changes could not sync to the cloud.',
        ),
        duration: const Duration(seconds: 6),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  void _onSyncErrorChanged() {
    if (!mounted) return;
    if (AppDataService.hasSyncError.value) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.syncOfflineWarning ??
                'No internet connection. Data may be outdated.',
          ),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }

  void _bindAuthAndAccessWatchers() {
    if (Firebase.apps.isEmpty) {
      return;
    }

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      user,
    ) async {
      await _accessProfileSubscription?.cancel();
      _accessProfileSubscription = null;

      if (user == null) {
        unawaited(AnalyticsService.logLogout());
        await _clearLocalAccessProfile(clearAuthUid: true);
        unawaited(
          AppDataService.stopCloudSync().catchError(
            (e) => debugPrint('[AuthGate] stopCloudSync error: $e'),
          ),
        );
        unawaited(
          OnlineBookingService.stop().catchError(
            (e) => debugPrint('[AuthGate] OnlineBookingService.stop error: $e'),
          ),
        );
        unawaited(
          RevenueCatService.logOut().catchError(
            (e) => debugPrint('[AuthGate] RevenueCatService.logOut error: $e'),
          ),
        );
        return;
      }
      unawaited(
        AnalyticsService.logLogin(
          method: user.providerData.isNotEmpty
              ? user.providerData.first.providerId
              : 'unknown',
        ),
      );

      final previousUid = _settingsBox.get('authUid')?.toString();
      if (previousUid != user.uid) {
        await _clearLocalAccessProfile();
      }

      await _settingsBox.put('authUid', user.uid);

      unawaited(
        OnlineBookingService.start().catchError(
          (e) => debugPrint('[AuthGate] OnlineBookingService.start error: $e'),
        ),
      );
      // Save FCM token
      unawaited(
        _saveCurrentFcmToken().catchError(
          (e) => debugPrint('[AuthGate] saveCurrentFcmToken error: $e'),
        ),
      );
      unawaited(
        RevenueCatService.configureAndLogin(user.uid).catchError(
          (e) => debugPrint(
            '[AuthGate] RevenueCatService.configureAndLogin error: $e',
          ),
        ),
      );

      _accessProfileSubscription = CloudProfileSync.watchAccessProfile().listen(
        (profile) async {
          if (!mounted) return;
          if (profile.isEmpty) return;
          await _applyAccessProfile(profile);
        },
      );
    });
  }

  Future<void> _clearLocalAccessProfile({bool clearAuthUid = false}) async {
    await _settingsBox.delete('businessMode');
    await _settingsBox.delete('appRole');
    await _settingsBox.delete('orgId');
    await _settingsBox.put('appPlan', AppPlan.free.name);
    await _settingsBox.put('planStatus', PlanStatus.inactive.name);
    await _settingsBox.delete('billingProvider');
    if (clearAuthUid) {
      await _settingsBox.delete('authUid');
    }
  }

  Future<void> _startCloudSyncIfReady() async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final orgId = _settingsBox.get('orgId')?.toString();
    if (user == null || orgId == null || orgId.isEmpty) {
      return;
    }

    await AppDataService.startCloudSync();
  }

  Future<void> _applyAccessProfile(Map<String, String> profile) async {
    final remoteMode = profile['businessMode'];
    final remoteRole = profile['appRole'];
    final remoteOrgId = profile['orgId'];
    final remotePlan = profile['appPlan'];
    final remotePlanStatus = profile['planStatus'];

    if (remoteMode != null && remoteMode.isNotEmpty) {
      await _settingsBox.put('businessMode', remoteMode);
    }

    if (remoteRole != null && remoteRole.isNotEmpty) {
      await _settingsBox.put('appRole', remoteRole);
    }

    if (remoteOrgId != null && remoteOrgId.isNotEmpty) {
      await _settingsBox.put('orgId', remoteOrgId);
    }

    if (remotePlan != null && remotePlan.isNotEmpty) {
      await _settingsBox.put('appPlan', remotePlan);
      unawaited(AnalyticsService.setPlan(remotePlan));
    }

    if (remotePlanStatus != null && remotePlanStatus.isNotEmpty) {
      await _settingsBox.put('planStatus', remotePlanStatus);
    }

    await _startCloudSyncIfReady();
  }

  Future<void> _hydrateAccessProfileFromCloud() async {
    if (Firebase.apps.isEmpty) {
      return;
    }

    final profile = await CloudProfileSync.fetchAccessProfile();
    if (profile == null || profile.isEmpty) {
      return;
    }

    await _applyAccessProfile(profile);
  }

  Future<void> _requestFcmPermission() async {
    if (Firebase.apps.isEmpty) return;
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      debugPrint('[FCM] requestPermission error: $e');
    }
  }

  Future<void> _checkForUpdate() async {
    final result = await ForceUpdateService.check();
    if (!result.required) return;
    if ((result.storeUrl ?? '').trim().isEmpty) return;
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _ForceUpdateDialog(storeUrl: result.storeUrl),
      );
    });
  }

  Future<void> _saveCurrentFcmToken() async {
    if (Firebase.apps.isEmpty) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await AppDataService.saveFcmToken(token);
      }
      // Refresh token listener
      _fcmTokenRefreshSub?.cancel();
      _fcmTokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(
        (newToken) => AppDataService.saveFcmToken(newToken).ignore(),
      );
    } catch (e) {
      debugPrint('[FCM] saveCurrentFcmToken error: $e');
    }
  }

  Future<void> _handleAuthenticated(String userLabel) async {
    await _settingsBox.put('isLoggedIn', true);
    await _settingsBox.put('authMode', 'firebase');
    await _settingsBox.put('authUserLabel', userLabel);
    await _settingsBox.put('authUid', FirebaseAuth.instance.currentUser?.uid);
    await CloudProfileSync.ensureUserProfile(fallbackName: userLabel);
    await CloudProfileSync.ensurePlanDefaults();
    await _hydrateAccessProfileFromCloud();
    await _startCloudSyncIfReady();
    await OnlineBookingService.start();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await RevenueCatService.configureAndLogin(uid);
    }
  }

  Future<void> _handleBusinessModeSelected(BusinessMode mode) async {
    final previousMode = _settingsBox.get('businessMode')?.toString();
    final previousRole = _settingsBox.get('appRole')?.toString();
    final previousOrgId = _settingsBox.get('orgId')?.toString();

    await _settingsBox.put('businessMode', mode.name);
    final role = mode == BusinessMode.team
        ? AppRole.director
        : AppRole.masterOwner;
    await _settingsBox.put('appRole', role.name);

    try {
      await CloudProfileSync.syncBusinessMode(mode);
    } catch (e) {
      if (previousMode == null || previousMode.isEmpty) {
        await _settingsBox.delete('businessMode');
      } else {
        await _settingsBox.put('businessMode', previousMode);
      }

      if (previousRole == null || previousRole.isEmpty) {
        await _settingsBox.delete('appRole');
      } else {
        await _settingsBox.put('appRole', previousRole);
      }

      if (previousOrgId == null || previousOrgId.isEmpty) {
        await _settingsBox.delete('orgId');
      } else {
        await _settingsBox.put('orgId', previousOrgId);
      }

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final message = l10n?.errorMessage(e.toString()) ?? e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    await CloudProfileSync.ensurePlanDefaults();
    if (Firebase.apps.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _settingsBox.put('orgId', 'org_${user.uid}');
      }
    }
    await _startCloudSyncIfReady();
  }

  Future<void> _finishOnboarding(bool skipped) async {
    await OnboardingPrefs.markPreAuthCompleted(_settingsBox, skipped: skipped);
  }

  Widget _buildAnimatedRoot(Widget child, String key) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (widget, animation) =>
          FadeTransition(opacity: animation, child: widget),
      child: KeyedSubtree(key: ValueKey<String>(key), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _settingsBox.listenable(
        keys: [
          'isLoggedIn',
          'businessMode',
          'authMode',
          'appRole',
          'appPlan',
          'planStatus',
          OnboardingPrefs.keyPreAuthCompleted,
          OnboardingPrefs.keyGlobalCompletedVersion,
        ],
      ),
      builder: (context, Box box, _) {
        final authMode =
            box.get('authMode', defaultValue: 'firebase') as String;
        final businessMode = BusinessMode.fromStorage(
          box.get('businessMode')?.toString(),
        );
        final appRole = AppRole.fromStorage(
          box.get('appRole')?.toString(),
          mode: businessMode,
        );

        final firebaseSessionActive = Firebase.apps.isNotEmpty
            ? FirebaseAuth.instance.currentUser != null
            : false;
        final hasValidSession = authMode == 'firebase' && firebaseSessionActive;

        final shouldShowPreAuthOnboarding = OnboardingPrefs.shouldShowPreAuth(
          box,
        );

        if (shouldShowPreAuthOnboarding) {
          return _buildAnimatedRoot(
            FirstRunOnboardingScreen(onFinish: _finishOnboarding),
            'onboarding_pre_auth',
          );
        }

        if (hasValidSession && businessMode != null) {
          return _buildAnimatedRoot(
            MainNavigationScreen(businessMode: businessMode, appRole: appRole),
            'main_${businessMode.name}_${appRole.name}',
          );
        }

        if (hasValidSession) {
          return _buildAnimatedRoot(
            BusinessModeScreen(onModeSelected: _handleBusinessModeSelected),
            'business_mode',
          );
        }

        return _buildAnimatedRoot(
          AuthScreen(onAuthenticated: _handleAuthenticated),
          'auth',
        );
      },
    );
  }
}

class _ForceUpdateDialog extends StatelessWidget {
  final String? storeUrl;

  const _ForceUpdateDialog({this.storeUrl});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasStoreUrl = storeUrl != null && storeUrl!.isNotEmpty;
    return PopScope(
      canPop: !hasStoreUrl,
      child: AlertDialog(
        title: Text(l10n.forceUpdateTitle),
        content: Text(l10n.forceUpdateMessage),
        actions: [
          if (hasStoreUrl)
            FilledButton(
              onPressed: () => launchUrl(
                Uri.parse(storeUrl!),
                mode: LaunchMode.externalApplication,
              ),
              child: Text(l10n.forceUpdateButton),
            )
          else
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.settingsClose),
            ),
        ],
      ),
    );
  }
}
