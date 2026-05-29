import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'analytics_service.dart';
import 'constants.dart';
import 'subscription_texts.dart';
import '../screens/pricing_screen.dart';

class AccessGuard {
  AccessGuard._();

  static const int freeClientsLimit = 20;
  static const int freeActiveOrdersPerMonthLimit = 10;

  static BusinessMode? currentBusinessMode() {
    final settingsBox = Hive.box(HiveBoxes.settings);
    return BusinessMode.fromStorage(
      settingsBox.get('businessMode')?.toString(),
    );
  }

  static AppRole currentRole() {
    final settingsBox = Hive.box(HiveBoxes.settings);
    final businessMode = currentBusinessMode();
    return AppRole.fromStorage(
      settingsBox.get('appRole')?.toString(),
      mode: businessMode,
    );
  }

  static AppPlan currentPlan() {
    final settingsBox = Hive.box(HiveBoxes.settings);
    return AppPlan.fromStorage(settingsBox.get('appPlan')?.toString());
  }

  static PlanStatus currentPlanStatus() {
    final settingsBox = Hive.box(HiveBoxes.settings);
    return PlanStatus.fromStorage(settingsBox.get('planStatus')?.toString());
  }

  static bool canManageBusinessData() {
    return currentRole().canManageBusinessData;
  }

  static bool canManageOrdersAndClients() {
    return currentRole().canManageOrdersAndClients;
  }

  static bool hasProAccess() {
    final plan = currentPlan();
    return currentPlanStatus().grantsAccess &&
        (plan == AppPlan.pro || plan == AppPlan.business);
  }

  static bool hasBusinessAccess() {
    return currentPlanStatus().grantsAccess &&
        currentPlan() == AppPlan.business;
  }

  static bool canUseAdvancedAnalytics() {
    return hasProAccess();
  }

  static bool canUseChatAttachments() {
    return hasProAccess();
  }

  static bool canUseTeamWorkspace() {
    return hasBusinessAccess();
  }

  static bool canUseCrmCampaigns() {
    return hasProAccess();
  }

  static bool canUseMarketingTools() {
    return hasProAccess();
  }

  static bool canUseOnlineBooking() {
    return hasProAccess();
  }

  static bool canUseAutomatedReminders() {
    return hasProAccess();
  }

  static bool enforcesFreePlanLimits() {
    return !hasProAccess();
  }

  /// Counts client records with a non-empty stable [id] (matches server quota).
  static int countClients(Box clientsBox) {
    var count = 0;
    for (final raw in clientsBox.values) {
      if (raw is! Map) continue;
      final id = raw['id']?.toString();
      if (id == null || id.isEmpty) continue;
      count++;
    }
    return count;
  }

  static bool canCreateClient({
    required int existingClientsCount,
    bool isEditing = false,
  }) {
    if (isEditing || !enforcesFreePlanLimits()) return true;
    final allowed = existingClientsCount < freeClientsLimit;
    if (!allowed) AnalyticsService.logFreeLimitReached(limitType: 'clients');
    return allowed;
  }

  static bool canCreateOrderThisMonth({
    required int activeOrdersThisMonthCount,
    bool isEditing = false,
  }) {
    if (isEditing || !enforcesFreePlanLimits()) return true;
    final allowed = activeOrdersThisMonthCount < freeActiveOrdersPerMonthLimit;
    if (!allowed) AnalyticsService.logFreeLimitReached(limitType: 'orders');
    return allowed;
  }

  static void showDenied(BuildContext context, {String? message}) {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? l10n?.settingsAccessDenied ?? 'Access denied.',
        ),
      ),
    );
  }

  static Future<void> showUpgradePrompt(
    BuildContext context, {
    required String title,
    required String message,
    required AppPlan requiredPlan,
  }) {
    AnalyticsService.logFeatureLockedTap(feature: title);
    bool didNavigateToPricing = false;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(message),
                const SizedBox(height: 12),
                Text(
                  SubscriptionTexts.requiredPlan(context, requiredPlan),
                  style: const TextStyle(color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      didNavigateToPricing = true;
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PricingScreen(),
                        ),
                      );
                    },
                    child: Text(SubscriptionTexts.viewPlans(context)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (!didNavigateToPricing) {
        AnalyticsService.logPricingScreenDismissed();
      }
    });
  }
}
