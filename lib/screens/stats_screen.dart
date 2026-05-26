import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../core/access_guard.dart';
import '../core/constants.dart';
import '../core/subscription_texts.dart';
import '../models/model_utils.dart';
import '../widgets/stat_card.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

enum _StatsPeriod { week, month, year }

enum _ChartMetric { revenue, orders }

class _StatsScreenState extends State<StatsScreen> {
  _StatsPeriod _period = _StatsPeriod.week;
  _ChartMetric _metric = _ChartMetric.revenue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final oBox = Hive.box(HiveBoxes.orders);
    final settingsBox = Hive.box(HiveBoxes.settings);
    final String currency = settingsBox.get('currency', defaultValue: '€');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.navStats),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: !AccessGuard.canUseAdvancedAnalytics()
          ? const _StatsUpgradeCard()
          : ValueListenableBuilder(
              valueListenable: oBox.listenable(),
              builder: (context, Box box, _) {
                final now = DateTime.now();
                final locale = Localizations.localeOf(context).toString();
                final orders = _collectOrders(box.values);
                final filteredOrders = _filterOrdersByPeriod(
                  orders,
                  _period,
                  now,
                );

                double totalRevenue = 0;
                double totalProfit = 0;
                for (final order in filteredOrders) {
                  final status = OrderStatus.fromName(
                    order['status']?.toString(),
                  );
                  if (status == OrderStatus.completed ||
                      status == OrderStatus.paid) {
                    totalRevenue += parseDouble(
                      order['price'],
                      field: 'Order.price',
                    );
                    totalProfit += _profit(order);
                  }
                }

                final points = _buildChartPoints(
                  orders: orders,
                  period: _period,
                  now: now,
                  locale: locale,
                );

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        _PeriodButton(
                          label: l10n.statsPeriodWeek,
                          isActive: _period == _StatsPeriod.week,
                          onTap: () =>
                              setState(() => _period = _StatsPeriod.week),
                        ),
                        const SizedBox(width: 8),
                        _PeriodButton(
                          label: l10n.statsPeriodMonth,
                          isActive: _period == _StatsPeriod.month,
                          onTap: () =>
                              setState(() => _period = _StatsPeriod.month),
                        ),
                        const SizedBox(width: 8),
                        _PeriodButton(
                          label: l10n.statsPeriodYear,
                          isActive: _period == _StatsPeriod.year,
                          onTap: () =>
                              setState(() => _period = _StatsPeriod.year),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    StatCard(
                      title: l10n.statsRevenue,
                      value: '${totalRevenue.toStringAsFixed(0)} $currency',
                      icon: Icons.monetization_on,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    StatCard(
                      title: l10n.statsProfit,
                      value: '${totalProfit.toStringAsFixed(0)} $currency',
                      icon: Icons.trending_up,
                      color: totalProfit >= 0
                          ? AppColors.primary
                          : AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    StatCard(
                      title: l10n.statsOrders,
                      value: '${filteredOrders.length}',
                      icon: Icons.shopping_bag,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _MetricButton(
                          label: l10n.statsRevenue,
                          isActive: _metric == _ChartMetric.revenue,
                          onTap: () {
                            setState(() => _metric = _ChartMetric.revenue);
                          },
                        ),
                        const SizedBox(width: 8),
                        _MetricButton(
                          label: l10n.statsOrders,
                          isActive: _metric == _ChartMetric.orders,
                          onTap: () {
                            setState(() => _metric = _ChartMetric.orders);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _metric == _ChartMetric.revenue
                          ? l10n.statsRevenue
                          : l10n.statsOrders,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _RevenueChart(
                      points: points,
                      currency: currency,
                      metric: _metric,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _metric == _ChartMetric.revenue
                          ? '${l10n.statsRevenue} ($currency)'
                          : l10n.statsOrders,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                );
              },
            ),
    );
  }

  List<Map<String, dynamic>> _collectOrders(Iterable<dynamic> rawValues) {
    final result = <Map<String, dynamic>>[];
    for (final raw in rawValues) {
      if (raw is Map) {
        result.add(Map<String, dynamic>.from(raw));
      }
    }
    return result;
  }

  List<Map<String, dynamic>> _filterOrdersByPeriod(
    List<Map<String, dynamic>> orders,
    _StatsPeriod period,
    DateTime now,
  ) {
    final start = _periodStart(period, now);
    final end = _periodEnd(period, now);

    return orders.where((order) {
      final orderDate = _extractOrderDate(order);
      if (orderDate == null) return false;
      return !orderDate.isBefore(start) && orderDate.isBefore(end);
    }).toList();
  }

  List<_ChartPoint> _buildChartPoints({
    required List<Map<String, dynamic>> orders,
    required _StatsPeriod period,
    required DateTime now,
    required String locale,
  }) {
    switch (period) {
      case _StatsPeriod.week:
        return _buildWeekPoints(orders, now);
      case _StatsPeriod.month:
        return _buildMonthPoints(orders, now);
      case _StatsPeriod.year:
        return _buildYearPoints(orders, now, locale);
    }
  }

  List<_ChartPoint> _buildWeekPoints(
    List<Map<String, dynamic>> orders,
    DateTime now,
  ) {
    final dayNow = DateTime(now.year, now.month, now.day);
    final points = <_ChartPoint>[];

    for (int i = 6; i >= 0; i--) {
      final day = dayNow.subtract(Duration(days: i));
      final next = day.add(const Duration(days: 1));

      final dayOrders = _ordersInRange(orders, day, next);
      points.add(
        _ChartPoint(
          label: DateFormat('dd.MM').format(day),
          orders: dayOrders.length,
          revenue: _revenue(dayOrders),
        ),
      );
    }

    return points;
  }

  List<_ChartPoint> _buildMonthPoints(
    List<Map<String, dynamic>> orders,
    DateTime now,
  ) {
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);
    final daysInMonth = monthEnd.difference(monthStart).inDays;
    final points = <_ChartPoint>[];

    int week = 0;
    for (int day = 1; day <= daysInMonth; day += 7) {
      week++;
      final start = DateTime(now.year, now.month, day);
      final endDay = (day + 7) > (daysInMonth + 1)
          ? (daysInMonth + 1)
          : (day + 7);
      final end = DateTime(now.year, now.month, endDay);
      final segmentOrders = _ordersInRange(orders, start, end);

      points.add(
        _ChartPoint(
          label: 'W$week',
          orders: segmentOrders.length,
          revenue: _revenue(segmentOrders),
        ),
      );
    }

    return points;
  }

  List<_ChartPoint> _buildYearPoints(
    List<Map<String, dynamic>> orders,
    DateTime now,
    String locale,
  ) {
    final points = <_ChartPoint>[];

    for (int month = 1; month <= 12; month++) {
      final start = DateTime(now.year, month, 1);
      final end = DateTime(now.year, month + 1, 1);
      final monthOrders = _ordersInRange(orders, start, end);

      points.add(
        _ChartPoint(
          label: DateFormat('MMM', locale).format(start),
          orders: monthOrders.length,
          revenue: _revenue(monthOrders),
        ),
      );
    }

    return points;
  }

  List<Map<String, dynamic>> _ordersInRange(
    List<Map<String, dynamic>> orders,
    DateTime start,
    DateTime end,
  ) {
    return orders.where((order) {
      final orderDate = _extractOrderDate(order);
      if (orderDate == null) return false;
      return !orderDate.isBefore(start) && orderDate.isBefore(end);
    }).toList();
  }

  DateTime _periodStart(_StatsPeriod period, DateTime now) {
    switch (period) {
      case _StatsPeriod.week:
        final day = DateTime(now.year, now.month, now.day);
        return day.subtract(const Duration(days: 6));
      case _StatsPeriod.month:
        return DateTime(now.year, now.month, 1);
      case _StatsPeriod.year:
        return DateTime(now.year, 1, 1);
    }
  }

  DateTime _periodEnd(_StatsPeriod period, DateTime now) {
    switch (period) {
      case _StatsPeriod.week:
        return DateTime(now.year, now.month, now.day + 1);
      case _StatsPeriod.month:
        return DateTime(now.year, now.month + 1, 1);
      case _StatsPeriod.year:
        return DateTime(now.year + 1, 1, 1);
    }
  }

  DateTime? _extractOrderDate(Map<String, dynamic> order) {
    final scheduled = order['scheduledDate'];
    if (scheduled is DateTime) return scheduled;
    if (scheduled is int) return DateTime.fromMillisecondsSinceEpoch(scheduled);

    final timestamp = order['timestamp'];
    if (timestamp is DateTime) return timestamp;
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);

    return null;
  }

  double _revenue(List<Map<String, dynamic>> orders) {
    double sum = 0;
    for (final order in orders) {
      final status = OrderStatus.fromName(order['status']?.toString());
      if (status == OrderStatus.completed || status == OrderStatus.paid) {
        sum += parseDouble(order['price'], field: 'Order.price');
      }
    }
    return sum;
  }

  double _profit(Map<String, dynamic> order) {
    final revenue = parseDouble(order['price'], field: 'Order.price');
    final materialCost = parseDouble(
      order['materialCost'],
      field: 'Order.materialCost',
    );
    final laborCost = parseDouble(
      order['laborCost'],
      field: 'Order.laborCost',
    );
    return revenue - materialCost - laborCost;
  }
}

class _StatsUpgradeCard extends StatelessWidget {
  const _StatsUpgradeCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SubscriptionTexts.statsProTitle(context),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(SubscriptionTexts.statsProSubtitle(context)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => AccessGuard.showUpgradePrompt(
                    context,
                    title: SubscriptionTexts.statsUpgradeTitle(context),
                    message: SubscriptionTexts.statsUpgradeMessage(context),
                    requiredPlan: AppPlan.pro,
                  ),
                  child: Text(SubscriptionTexts.viewPlans(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MetricButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.success.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? AppColors.success : Colors.white12,
            ),
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? AppColors.success : Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartPoint {
  final String label;
  final int orders;
  final double revenue;

  const _ChartPoint({
    required this.label,
    required this.orders,
    required this.revenue,
  });
}

class _RevenueChart extends StatelessWidget {
  final List<_ChartPoint> points;
  final String currency;
  final _ChartMetric metric;

  const _RevenueChart({
    required this.points,
    required this.currency,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = points.isEmpty
        ? 1.0
        : points
              .map(
                (p) => metric == _ChartMetric.revenue
                    ? p.revenue
                    : p.orders.toDouble(),
              )
              .fold<double>(0, (a, b) => a > b ? a : b);
    final safeMax = maxValue <= 0 ? 1.0 : maxValue;
    final barColor = metric == _ChartMetric.revenue
        ? AppColors.primary
        : AppColors.success;

    return Container(
      height: 230,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: points.isEmpty
          ? const Center(
              child: Icon(Icons.show_chart, size: 52, color: Colors.grey),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: points.asMap().entries.map((entry) {
                  final index = entry.key;
                  final point = entry.value;
                  final value = metric == _ChartMetric.revenue
                      ? point.revenue
                      : point.orders.toDouble();
                  final targetHeight = (value / safeMax) * 120;
                  final labelValue = metric == _ChartMetric.revenue
                      ? '${point.revenue.toStringAsFixed(0)} $currency'
                      : '${point.orders}';

                  return Container(
                    width: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          labelValue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TweenAnimationBuilder<double>(
                          key: ValueKey('${metric.name}_${point.label}'),
                          tween: Tween(
                            begin: 0,
                            end: targetHeight < 6 ? 6 : targetHeight,
                          ),
                          duration: Duration(milliseconds: 280 + (index * 70)),
                          curve: Curves.easeOutCubic,
                          builder: (context, animatedHeight, child) {
                            return Container(
                              height: animatedHeight,
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          point.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${point.orders}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
