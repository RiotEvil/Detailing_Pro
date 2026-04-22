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
import 'core/hive_setup.dart';
import 'core/notification_center.dart';
import 'core/online_booking_service.dart';
import 'core/order_reminder_service.dart';
import 'core/revenuecat_service.dart';
import 'core/theme.dart';
import 'package:flutter_application_1/screens/main_navigation_screen.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';
import 'package:flutter_application_1/screens/business_mode_screen.dart';

/// FCM background message handler — must be a top-level function.
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message: ${message.notification?.title}');
}

void main() async {
  // 1. Обязательная привязка Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Disable debug prints in release builds
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  try {
    // 2. Инициализация Hive
    await Hive.initFlutter();

    // 3. Открываем все боксы и выполняем стартовый сидинг
    await setupHiveBoxes();

    // 4. Настройка времени и уведомлений
    await initializeDateFormatting();
    await _setupNotifications();
  } catch (e) {
    // Если здесь выскочит ошибка, мы увидим её в консоли
    debugPrint('APP STARTUP ERROR: $e');
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
          ),
        ),
      );
    });
  } catch (e) {
    debugPrint('Firebase is not initialized: $e');
  }

  runApp(const DetailingProApp());
}

/// Настройка уведомлений, чтобы не загромождать main
Future<void> _setupNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
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

class _AuthGateState extends State<AuthGate> {
  late final Box _settingsBox;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<Map<String, String>>? _accessProfileSubscription;
  StreamSubscription<String>? _fcmTokenRefreshSub;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box(HiveBoxes.settings);
    _hydrateAccessProfileFromCloud();
    _bindAuthAndAccessWatchers();
    _requestFcmPermission();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _accessProfileSubscription?.cancel();
    _fcmTokenRefreshSub?.cancel();
    super.dispose();
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
          if (profile.isEmpty) {
            return;
          }

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
    await RevenueCatService.configureAndLogin(
      FirebaseAuth.instance.currentUser?.uid,
    );
  }

  Future<void> _handleBusinessModeSelected(BusinessMode mode) async {
    await _settingsBox.put('businessMode', mode.name);
    final role = mode == BusinessMode.team
        ? AppRole.director
        : AppRole.masterOwner;
    await _settingsBox.put('appRole', role.name);
    await CloudProfileSync.syncBusinessMode(mode);
    await CloudProfileSync.ensurePlanDefaults();
    if (Firebase.apps.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _settingsBox.put('orgId', 'org_${user.uid}');
      }
    }
    await _startCloudSyncIfReady();
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
