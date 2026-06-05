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

      // Pro plan
      final proOffering = offerings.getOffering('pro') ?? offerings.current;
      final proPkg =
          proOffering?.monthly ??
          proOffering?.annual ??
          proOffering?.availablePackages.firstOrNull;
      if (proPkg != null) {
        prices[AppPlan.pro] = proPkg.storeProduct.priceString;
      }

      // Business plan
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

  String _price(BuildContext context, AppPlan plan) {
    return _livePrices[plan] ?? SubscriptionTexts.planPrice(context, plan);
  }

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box(HiveBoxes.settings);
    final revenueCatEnabled = RevenueCatConfig.isEnabledForCurrentPlatform;

    return Scaffold(
      appBar: AppBar(
        title: Text(SubscriptionTexts.pricingTitle(context)),
        backgroundColor: AppColors.surface,
      ),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _IntroCard(
                currentPlan: currentPlan,
                planStatus: planStatus,
                trialEndsAt: trialEndsAt,
              ),
              if (!revenueCatEnabled) ...[
                const SizedBox(height: 16),
                const _PurchasesUnavailableCard(),
              ],
              const SizedBox(height: 16),
              _PlanCard(
                title: SubscriptionTexts.planName(context, AppPlan.free),
                price: _price(context, AppPlan.free),
                accent: AppColors.info,
                currentPlan: currentPlan,
                plan: AppPlan.free,
                description: SubscriptionTexts.planDescription(
                  context,
                  AppPlan.free,
                ),
                features: SubscriptionTexts.planFeatures(context, AppPlan.free),
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: SubscriptionTexts.planName(context, AppPlan.pro),
                price: _pricesLoading ? '...' : _price(context, AppPlan.pro),
                accent: AppColors.primary,
                currentPlan: currentPlan,
                plan: AppPlan.pro,
                highlighted: true,
                purchasable: true,
                showTrial: true,
                canBuy: !_pricesLoading && _livePrices.containsKey(AppPlan.pro),
                description: SubscriptionTexts.planDescription(
                  context,
                  AppPlan.pro,
                ),
                features: SubscriptionTexts.planFeatures(context, AppPlan.pro),
              ),
              const SizedBox(height: 12),
              _PlanCard(
                title: SubscriptionTexts.planName(context, AppPlan.business),
                price: _pricesLoading
                    ? '...'
                    : _price(context, AppPlan.business),
                accent: AppColors.success,
                currentPlan: currentPlan,
                plan: AppPlan.business,
                purchasable: true,
                canBuy: !_pricesLoading && _livePrices.containsKey(AppPlan.business),
                description: SubscriptionTexts.planDescription(
                  context,
                  AppPlan.business,
                ),
                features: SubscriptionTexts.planFeatures(
                  context,
                  AppPlan.business,
                ),
              ),
              const SizedBox(height: 20),
              const _RestorePurchasesCard(),
            ],
          );
        },
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.currentPlan,
    required this.planStatus,
    this.trialEndsAt,
  });

  final AppPlan currentPlan;
  final PlanStatus planStatus;
  final int? trialEndsAt;

  @override
  Widget build(BuildContext context) {
    final daysLeft = _trialDaysLeft();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SubscriptionTexts.pricingIntroTitle(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(SubscriptionTexts.pricingIntroBody(context)),
            const SizedBox(height: 12),
            Text(
              SubscriptionTexts.currentPlanLine(
                context,
                currentPlan,
                planStatus,
              ),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (daysLeft != null) ...[
              const SizedBox(height: 12),
              _TrialCountdownBanner(daysLeft: daysLeft),
            ],
          ],
        ),
      ),
    );
  }

  int? _trialDaysLeft() {
    if (planStatus != PlanStatus.trial || trialEndsAt == null) return null;
    final end = DateTime.fromMillisecondsSinceEpoch(trialEndsAt!);
    final remaining = end.difference(DateTime.now());
    if (remaining.isNegative) return null;
    return (remaining.inHours / 24).ceil().clamp(1, 999);
  }
}

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
        border: Border.all(color: color.withValues(alpha: 0.4)),
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

class _PlanCard extends StatefulWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.accent,
    required this.plan,
    required this.currentPlan,
    this.highlighted = false,
    this.purchasable = false,
    this.canBuy = false,
    this.showTrial = false,
  });

  final String title;
  final String price;
  final String description;
  final List<String> features;
  final Color accent;
  final AppPlan plan;
  final AppPlan currentPlan;
  final bool highlighted;
  final bool purchasable;
  final bool canBuy;
  final bool showTrial;

  @override
  State<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<_PlanCard> {
  bool _purchasing = false;

  Future<void> _purchase() async {
    if (_purchasing) return;
    if (!RevenueCatConfig.isEnabledForCurrentPlatform) {
      _showPurchasesUnavailableSnackBar(context);
      return;
    }

    setState(() => _purchasing = true);
    try {
      await RevenueCatService.purchasePlan(widget.plan);
      AnalyticsService.logPlanUpgrade(
        plan: widget.plan.name,
        revenue: widget.plan == AppPlan.pro ? 10.0 : 39.0,
      ).ignore();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(SubscriptionTexts.planActivated(context, widget.title)),
        ),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            SubscriptionTexts.purchaseFailed(
              context,
              e.message ?? e.code,
            ),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            SubscriptionTexts.purchaseFailed(
              context,
              'Please try again later.',
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentPlan = widget.currentPlan == widget.plan;
    final showBuyButton =
        widget.purchasable && !isCurrentPlan;
    final buttonEnabled = widget.canBuy && !_purchasing;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: widget.highlighted ? widget.accent : Colors.white12,
          width: widget.highlighted ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isCurrentPlan)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      SubscriptionTexts.currentBadge(context),
                      style: TextStyle(
                        color: widget.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (widget.highlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      SubscriptionTexts.recommendedBadge(context),
                      style: TextStyle(
                        color: widget.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.price,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.accent,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.description),
            const SizedBox(height: 12),
            ...widget.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: widget.accent,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
            ),
            if (showBuyButton) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: buttonEnabled ? _purchase : null,
                  child: _purchasing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.showTrial
                              ? SubscriptionTexts.trialCta(context)
                              : SubscriptionTexts.choosePlan(
                                  context,
                                  widget.title,
                                ),
                        ),
                ),
              ),
              if (widget.showTrial) ...[
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    SubscriptionTexts.afterTrialNote(context, widget.price),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _RestorePurchasesCard extends StatelessWidget {
  const _RestorePurchasesCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              if (!RevenueCatConfig.isEnabledForCurrentPlatform) {
                _showPurchasesUnavailableSnackBar(context);
                return;
              }
              try {
                await RevenueCatService.restorePurchases();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(SubscriptionTexts.purchasesRestored(context)),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      SubscriptionTexts.restoreFailed(context, e.toString()),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.restore),
            label: Text(SubscriptionTexts.restorePurchasesLabel(context)),
          ),
        ),
      ),
    );
  }
}

class _PurchasesUnavailableCard extends StatelessWidget {
  const _PurchasesUnavailableCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.warning.withValues(alpha: 0.10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: AppColors.warning),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'In-app purchases unavailable',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Purchases are not available in this build. Please download the latest version from the store.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
