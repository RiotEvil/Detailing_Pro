import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../core/analytics_service.dart';
import '../core/constants.dart';
import '../core/revenuecat_config.dart';
import '../core/revenuecat_service.dart';
import '../core/subscription_texts.dart';

void _showPurchasesUnavailableSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Purchases are unavailable in this build. Provide a valid RevenueCat public SDK key to enable buying and restore.',
      ),
    ),
  );
}

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  Map<AppPlan, String> _livePrices = {};
  bool _pricesLoading = true;
  bool _purchasingPro = false;
  bool _purchasingBiz = false;

  @override
  void initState() {
    super.initState();
    _loadLivePrices();
    AnalyticsService.logPricingScreenOpened();
  }

  Future<void> _loadLivePrices() async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform) {
      if (mounted) setState(() => _pricesLoading = false);
      return;
    }
    try {
      final offerings = await Purchases.getOfferings();
      final prices = <AppPlan, String>{};

      final proOffering = offerings.getOffering('pro') ?? offerings.current;
      final proPkg =
          proOffering?.monthly ??
          proOffering?.annual ??
          proOffering?.availablePackages.firstOrNull;
      if (proPkg != null) {
        prices[AppPlan.pro] = proPkg.storeProduct.priceString;
      }

      final bizOffering = offerings.getOffering('business');
      final bizPkg =
          bizOffering?.monthly ??
          bizOffering?.annual ??
          bizOffering?.availablePackages.firstOrNull;
      if (bizPkg != null) {
        prices[AppPlan.business] = bizPkg.storeProduct.priceString;
      }

      if (mounted) {
        setState(() {
          _livePrices = prices;
          _pricesLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[PricingScreen] loadLivePrices error: $e');
      if (mounted) setState(() => _pricesLoading = false);
    }
  }

  Future<void> _purchasePlan(AppPlan plan) async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform) {
      _showPurchasesUnavailableSnackBar(context);
      return;
    }

    setState(() {
      if (plan == AppPlan.pro) {
        _purchasingPro = true;
      } else {
        _purchasingBiz = true;
      }
    });

    try {
      await RevenueCatService.purchasePlan(plan);
      AnalyticsService.logPlanUpgrade(
        plan: plan.name,
        revenue: plan == AppPlan.pro ? 10.0 : 39.0,
      ).ignore();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            SubscriptionTexts.planActivated(
              context,
              SubscriptionTexts.planName(context, plan),
            ),
          ),
        ),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            SubscriptionTexts.purchaseFailed(context, e.message ?? e.code),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            SubscriptionTexts.purchaseFailed(context, 'Please try again later.'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _purchasingPro = _purchasingBiz = false);
    }
  }

  Future<void> _restore() async {
    if (!RevenueCatConfig.isEnabledForCurrentPlatform) {
      _showPurchasesUnavailableSnackBar(context);
      return;
    }
    try {
      await RevenueCatService.restorePurchases();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SubscriptionTexts.purchasesRestored(context))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(SubscriptionTexts.restoreFailed(context, e.toString())),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box(HiveBoxes.settings);
    final revenueCatEnabled = RevenueCatConfig.isEnabledForCurrentPlatform;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder(
        valueListenable: settingsBox.listenable(
          keys: ['appPlan', 'planStatus', 'trialEndsAt'],
        ),
        builder: (context, Box box, _) {
          final currentPlan = AppPlan.fromStorage(
            box.get('appPlan')?.toString(),
          );
          final planStatus = PlanStatus.fromStorage(
            box.get('planStatus')?.toString(),
          );
          final trialEndsAt = box.get('trialEndsAt') as int?;

          final hasProAccess =
              currentPlan == AppPlan.pro || currentPlan == AppPlan.business;
          final proPrice = _pricesLoading
              ? '...'
              : (_livePrices[AppPlan.pro] ??
                    SubscriptionTexts.planPrice(context, AppPlan.pro));
          final bizPrice = _pricesLoading
              ? '...'
              : (_livePrices[AppPlan.business] ??
                    SubscriptionTexts.planPrice(context, AppPlan.business));
          final canBuyPro =
              !_pricesLoading &&
              _livePrices.containsKey(AppPlan.pro) &&
              !hasProAccess;
          final canBuyBiz =
              !_pricesLoading &&
              _livePrices.containsKey(AppPlan.business) &&
              currentPlan != AppPlan.business;

          int? trialDaysLeft;
          if (planStatus == PlanStatus.trial && trialEndsAt != null) {
            final end = DateTime.fromMillisecondsSinceEpoch(trialEndsAt);
            final remaining = end.difference(DateTime.now());
            if (!remaining.isNegative) {
              trialDaysLeft = (remaining.inHours / 24).ceil().clamp(1, 999);
            }
          }

          return SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Headline
                        Text(
                          SubscriptionTexts.paywallHeadline(context),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 2. Subtitle
                        Text(
                          SubscriptionTexts.paywallSubtitle(context),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.60),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 3. Benefit rows
                        _BenefitRow(
                          emoji: '🗂',
                          text: SubscriptionTexts.paywallBenefit1(context),
                        ),
                        const SizedBox(height: 10),
                        _BenefitRow(
                          emoji: '📊',
                          text: SubscriptionTexts.paywallBenefit2(context),
                        ),
                        const SizedBox(height: 10),
                        _BenefitRow(
                          emoji: '🔔',
                          text: SubscriptionTexts.paywallBenefit3(context),
                        ),
                        const SizedBox(height: 32),

                        // RevenueCat unavailable warning
                        if (!revenueCatEnabled) ...[
                          const _PurchasesUnavailableCard(),
                          const SizedBox(height: 16),
                        ],

                        // Trial countdown
                        if (trialDaysLeft != null) ...[
                          _TrialCountdownBanner(daysLeft: trialDaysLeft),
                          const SizedBox(height: 16),
                        ],

                        // 4. Pro price block
                        _ProPriceBlock(
                          price: proPrice,
                          canBuy: canBuyPro,
                          purchasing: _purchasingPro,
                          isCurrentPlan: currentPlan == AppPlan.pro,
                          hasBusiness: currentPlan == AppPlan.business,
                          onPurchase: () => _purchasePlan(AppPlan.pro),
                        ),
                        const SizedBox(height: 16),

                        // 5. Tagline
                        Center(
                          child: Text(
                            SubscriptionTexts.paywallTagline(context),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.40),
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Business secondary option
                        if (currentPlan != AppPlan.business)
                          _BusinessSecondaryRow(
                            price: bizPrice,
                            canBuy: canBuyBiz,
                            purchasing: _purchasingBiz,
                            onPurchase: () => _purchasePlan(AppPlan.business),
                          ),
                        const SizedBox(height: 4),

                        // Restore purchases
                        Center(
                          child: TextButton(
                            onPressed: _restore,
                            child: Text(
                              SubscriptionTexts.restorePurchasesLabel(context),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.35),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Benefit row
// ---------------------------------------------------------------------------

class _BenefitRow extends StatelessWidget {
  final String emoji;
  final String text;

  const _BenefitRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pro price block
// ---------------------------------------------------------------------------

class _ProPriceBlock extends StatelessWidget {
  final String price;
  final bool canBuy;
  final bool purchasing;
  final bool isCurrentPlan;
  final bool hasBusiness;
  final VoidCallback onPurchase;

  const _ProPriceBlock({
    required this.price,
    required this.canBuy,
    required this.purchasing,
    required this.isCurrentPlan,
    required this.hasBusiness,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final alreadyHasAccess = isCurrentPlan || hasBusiness;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.50),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (alreadyHasAccess)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.30),
                ),
              ),
              child: Center(
                child: Text(
                  SubscriptionTexts.paywallActiveBadge(context),
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canBuy && !purchasing ? onPurchase : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: purchasing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        SubscriptionTexts.trialCta(context),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          if (!alreadyHasAccess) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                SubscriptionTexts.afterTrialNote(context, price),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.40),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Business secondary row
// ---------------------------------------------------------------------------

class _BusinessSecondaryRow extends StatelessWidget {
  final String price;
  final bool canBuy;
  final bool purchasing;
  final VoidCallback onPurchase;

  const _BusinessSecondaryRow({
    required this.price,
    required this.canBuy,
    required this.purchasing,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: canBuy && !purchasing ? onPurchase : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.people_alt_outlined,
              color: Colors.white38,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                SubscriptionTexts.paywallBusinessLabel(context, price),
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ),
            if (purchasing)
              const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white38,
                ),
              )
            else
              const Icon(
                Icons.chevron_right,
                color: Colors.white38,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trial countdown banner
// ---------------------------------------------------------------------------

class _TrialCountdownBanner extends StatelessWidget {
  const _TrialCountdownBanner({required this.daysLeft});
  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    final color = daysLeft <= 2 ? AppColors.error : AppColors.warning;
    final label = daysLeft == 0
        ? 'Trial expires today!'
        : daysLeft == 1
        ? '1 day left in your trial'
        : '$daysLeft days left in your trial';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.40)),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Purchases unavailable notice
// ---------------------------------------------------------------------------

class _PurchasesUnavailableCard extends StatelessWidget {
  const _PurchasesUnavailableCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Purchases are not available in this build.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
