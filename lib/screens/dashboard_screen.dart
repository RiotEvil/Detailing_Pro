import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../core/app_data_service.dart';
import '../core/access_guard.dart';
import '../core/constants.dart';
import '../core/order_services.dart';
import '../core/order_reminder_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/confirm_dialog.dart';
import 'add_job_screen.dart';
import 'add_client_screen.dart';
import 'jobs_screen.dart';
import 'clients_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- ЛОГИКА АВТОМАТИЧЕСКОГО СПИСАНИЯ ХИМИИ ---
  Future<void> _completeOrder(
    dynamic orderKey,
    Map orderData,
    AppLocalizations l10n,
  ) async {
    // 1. Спрашиваем подтверждение
    final bool? confirmed = await ConfirmDialog.show(
      context: context,
      title: orderData['car'] ?? l10n.orderDefaultTitle,
      message: l10n.completeOrderAndConsumePrompt,
    );

    if (confirmed != true) return;

    final servicesBox = Hive.box(HiveBoxes.services);
    final inventoryBox = Hive.box(HiveBoxes.inventory);
    final ordersBox = Hive.box(HiveBoxes.orders);

    // 2. Ищем настройки услуги
    final serviceNames = orderServiceList(orderData);
    for (final serviceName in serviceNames) {
      final service = servicesBox.values.firstWhere(
        (s) => s['name'] == serviceName,
        orElse: () => null,
      );

      if (service == null || service['chemistry'] == null) {
        continue;
      }

      final chemRaw = service['chemistry'];
      if (chemRaw is! List) continue;
      final selectedChems = List.from(chemRaw);
      final consumption = (service['chemAmount'] as num?)?.toInt() ?? 0;
      final perChemConsumption = selectedChems.isEmpty
          ? consumption
          : (consumption / selectedChems.length).ceil();

      for (final chemName in selectedChems) {
        final invKey = inventoryBox.keys.firstWhere(
          (k) {
            final v = inventoryBox.get(k);
            return v is Map && v['name'] == chemName;
          },
          orElse: () => null,
        );

        if (invKey != null) {
          final item = Map<String, dynamic>.from(inventoryBox.get(invKey));
          final currentStock = (item['amount'] as num?)?.toInt() ?? 0;
          item['amount'] = (currentStock - perChemConsumption).clamp(0, 999999);
          await inventoryBox.put(invKey, item);
          unawaited(
            AppDataService.syncInventoryItemToCloud(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    // 3. Обновляем статус заказа
    final updatedOrder = Map<String, dynamic>.from(orderData);
    if ((updatedOrder['id']?.toString().isEmpty ?? true)) {
      updatedOrder['id'] = DateTime.now().microsecondsSinceEpoch.toString();
    }
    updatedOrder['status'] = OrderStatus.completed.name;
    await ordersBox.put(orderKey, updatedOrder);
    unawaited(AppDataService.syncOrderToCloud(updatedOrder));
    unawaited(
      OrderReminderService.cancelForOrder(updatedOrder['id']?.toString()),
    );

    // ВЫВОДИМ СНЭКБАР БЕЗ ИСПОЛЬЗОВАНИЯ l10n.ready
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.orderCompletedSnack(orderData['car']?.toString() ?? ''),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSmallPhone = MediaQuery.of(context).size.width < 380;
    final settingsBox = Hive.box(HiveBoxes.settings);
    final String currency = settingsBox.get('currency', defaultValue: '€');
    final String locale = settingsBox.get('locale', defaultValue: 'en');
    final oBox = Hive.box(HiveBoxes.orders);
    final cBox = Hive.box(HiveBoxes.clients);
    final canManageBusinessData = AccessGuard.canManageOrdersAndClients();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder(
        valueListenable: oBox.listenable(),
        builder: (context, Box ordersBox, _) {
          final orderEntries = ordersBox.keys
              .map((key) {
                final raw = ordersBox.get(key);
                if (raw is! Map) return null;
                return MapEntry<dynamic, Map<String, dynamic>>(
                  key,
                  Map<String, dynamic>.from(raw),
                );
              })
              .whereType<MapEntry<dynamic, Map<String, dynamic>>>()
              .toList();

          // Фильтрация данных для статистики
          final today = DateTime.now();
          final todayStart = DateTime(today.year, today.month, today.day);
          final todayEnd = todayStart.add(const Duration(days: 1));

          // Заказы на сегодня (объекты и их ключи)
          final todayOrders = <Map<String, dynamic>>[];
          final todayKeys = <dynamic>[];

          for (final entry in orderEntries) {
            final key = entry.key;
            final o = entry.value;
            final scheduledDate = (o['scheduledDate'] as num?)?.toInt();
            if (scheduledDate == null || scheduledDate <= 0) continue;
            final date = DateTime.fromMillisecondsSinceEpoch(scheduledDate);
            if (!date.isBefore(todayStart) && date.isBefore(todayEnd)) {
              todayOrders.add(o);
              todayKeys.add(key);
            }
          }

          final inProgressOrders = orderEntries.where((entry) {
            final o = entry.value;
            final status = OrderStatus.fromName(o['status']?.toString());
            return status == OrderStatus.inProgress;
          }).toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            OrderReminderService.syncForOrders(
              orders: orderEntries.map((entry) => entry.value),
              l10n: l10n,
            ).ignore();
          });

          double todayRevenue = 0;
          for (final order in todayOrders) {
            final status = OrderStatus.fromName(order['status']?.toString());
            if (status == OrderStatus.completed || status == OrderStatus.paid) {
              todayRevenue += (order['price'] as num?)?.toDouble() ?? 0;
            }
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(l10n),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat.yMMMMEEEEd(locale).format(today),
                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 24),

                      // Сетка статистики
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: isSmallPhone ? 1.25 : 1.45,
                        children: [
                          StatCard(
                            title: l10n.statsTodayOrders,
                            value: '${todayOrders.length}',
                            icon: Icons.calendar_today,
                            color: AppColors.info,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const JobsScreen(),
                              ),
                            ),
                          ),
                          StatCard(
                            title: l10n.statsInWork,
                            value: '${inProgressOrders.length}',
                            icon: Icons.build,
                            color: AppColors.warning,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const JobsScreen(),
                              ),
                            ),
                          ),
                          StatCard(
                            title: l10n.statsTodayRevenue,
                            value:
                                '${todayRevenue.toStringAsFixed(0)} $currency',
                            icon: Icons.payments,
                            color: AppColors.success,
                          ),
                          StatCard(
                            title: l10n.statsTotalClients,
                            value: '${cBox.length}',
                            icon: Icons.people,
                            color: AppColors.primary,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClientsScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Text(
                        l10n.quickActions,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.add_task,
                              label: l10n.newOrder,
                              color: AppColors.primary,
                              onTap: canManageBusinessData
                                  ? () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AddJobScreen(),
                                      ),
                                    )
                                  : () => AccessGuard.showDenied(
                                      context,
                                      message: l10n.permissionCreateOrderDenied,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionButton(
                              icon: Icons.person_add,
                              label: l10n.newClient,
                              color: AppColors.info,
                              onTap: canManageBusinessData
                                  ? () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AddClientScreen(),
                                      ),
                                    )
                                  : () => AccessGuard.showDenied(
                                      context,
                                      message:
                                          l10n.permissionCreateClientDenied,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (todayOrders.isNotEmpty)
                        Text(
                          l10n.todayOrdersTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Список заказов на сегодня
              if (todayOrders.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        l10n.noOrdersTitle,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final order = todayOrders[index];
                      final orderKey = todayKeys[index];
                      final status = order['status'] as String?;
                      final bool isDone =
                          OrderStatus.fromName(status) == OrderStatus.completed;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(status),
                            child: Icon(
                              _getStatusIcon(status),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            order['car'] ?? l10n.carLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            '${order['client']} • ${orderServicesSummary(order)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                order['scheduledTime'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!isDone)
                                IconButton(
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () =>
                                      _completeOrder(orderKey, order, l10n),
                                ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: todayOrders.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // --- ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ---

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 18) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  Color _getStatusColor(String? status) {
    final orderStatus = OrderStatus.fromName(status);
    switch (orderStatus) {
      case OrderStatus.scheduled:
        return AppColors.info;
      case OrderStatus.inProgress:
        return AppColors.warning;
      case OrderStatus.ready:
        return AppColors.success;
      case OrderStatus.completed:
      case OrderStatus.paid:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    final orderStatus = OrderStatus.fromName(status);
    switch (orderStatus) {
      case OrderStatus.scheduled:
        return Icons.schedule;
      case OrderStatus.inProgress:
        return Icons.build;
      case OrderStatus.ready:
        return Icons.check;
      case OrderStatus.completed:
      case OrderStatus.paid:
        return Icons.done_all;
    }
  }
}

// Виджет кнопки быстрых действий
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
