import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../core/app_data_service.dart';
import '../core/cloud_file_storage.dart';
import '../core/constants.dart';
import '../core/order_services.dart';
import '../core/order_reminder_service.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/empty_state.dart';
import 'add_job_screen.dart';
import 'client_details_screen.dart';
import 'order_details_screen.dart';
import '../models/models.dart';

enum _OrdersViewFilter { active, completed }

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  _OrdersViewFilter _filter = _OrdersViewFilter.active;

  void _deleteOrderPhotos(Map order) {
    final paths = <String>[
      ...((order['beforePhotos'] as List?)?.map((e) => e.toString()) ?? []),
      ...((order['afterPhotos'] as List?)?.map((e) => e.toString()) ?? []),
      ...((order['photos'] as List?)?.map((e) => e.toString()) ?? []),
    ];
    for (final path in paths) {
      if (path.isEmpty) continue;
      if (path.startsWith('http')) {
        unawaited(CloudFileStorage.deleteOrderPhoto(path));
        continue;
      }
      try {
        final f = File(path);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }
  }

  bool _canMasterAccessOrder(
    Map<String, dynamic> order,
    String? currentUid,
    String? currentUserLabel,
  ) {
    final assignedUid = order['assignedToUid']?.toString();
    final assignedName = order['assignedToName']
        ?.toString()
        .trim()
        .toLowerCase();
    final assignedToCurrentUid =
        currentUid != null && assignedUid != null && assignedUid == currentUid;
    final assignedToCurrentLabel =
        currentUserLabel != null &&
        currentUserLabel.isNotEmpty &&
        assignedName != null &&
        assignedName == currentUserLabel;
    final unassigned =
        (assignedUid == null || assignedUid.isEmpty) &&
        (assignedName == null || assignedName.isEmpty);

    return assignedToCurrentUid || assignedToCurrentLabel || unassigned;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsBox = Hive.box(HiveBoxes.settings);
    final String currency = settingsBox.get('currency', defaultValue: '€');
    final businessMode = BusinessMode.fromStorage(
      settingsBox.get('businessMode')?.toString(),
    );
    final appRole = AppRole.fromStorage(
      settingsBox.get('appRole')?.toString(),
      mode: businessMode,
    );
    final canManageOrders = appRole.canManageOrdersAndClients;
    final canDeleteOrders = appRole.canManageBusinessData;
    final isTeamMode = businessMode == BusinessMode.team;
    final currentUid = Firebase.apps.isNotEmpty
        ? FirebaseAuth.instance.currentUser?.uid
        : null;
    final currentUserLabel = settingsBox
        .get('authUserLabel')
        ?.toString()
        .trim()
        .toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder(
        valueListenable: Hive.box(HiveBoxes.orders).listenable(),
        builder: (context, Box box, _) {
          final l10n = AppLocalizations.of(context)!;
          final entries = <MapEntry<dynamic, Map<String, dynamic>>>[];
          for (final key in box.keys) {
            final raw = box.get(key);
            if (raw is Map) {
              entries.add(MapEntry(key, Map<String, dynamic>.from(raw)));
            }
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            OrderReminderService.syncForOrders(
              orders: entries.map((entry) => entry.value),
              l10n: l10n,
            ).ignore();
          });

          if (entries.isEmpty) {
            return EmptyState(
              icon: Icons.inbox_rounded,
              title: l10n.noOrdersTitle,
              subtitle: l10n.noOrdersSubtitle,
              actionLabel: l10n.addOrder,
              onAction: canManageOrders
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddJobScreen()),
                    )
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.permissionCreateOrderDenied)),
                    ),
            );
          }

          final filtered =
              entries.where((entry) {
                if (isTeamMode && appRole == AppRole.master) {
                  if (!_canMasterAccessOrder(
                    entry.value,
                    currentUid,
                    currentUserLabel,
                  )) {
                    return false;
                  }
                }

                final status = entry.value['status']?.toString();
                final isCompleted = _isCompletedStatus(status);
                return _filter == _OrdersViewFilter.active
                    ? !isCompleted
                    : isCompleted;
              }).toList()..sort((a, b) {
                final statusA = _getStatusPriority(
                  a.value['status']?.toString(),
                );
                final statusB = _getStatusPriority(
                  b.value['status']?.toString(),
                );
                if (_filter == _OrdersViewFilter.active && statusA != statusB) {
                  return statusA.compareTo(statusB);
                }

                final aDate = (a.value['scheduledDate'] as num?)?.toInt() ?? 0;
                final bDate = (b.value['scheduledDate'] as num?)?.toInt() ?? 0;
                return bDate.compareTo(aDate);
              });

          if (filtered.isEmpty) {
            return SafeArea(
              top: true,
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.statusInProgress),
                            selected: _filter == _OrdersViewFilter.active,
                            onSelected: (_) => setState(
                              () => _filter = _OrdersViewFilter.active,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.statusCompleted),
                            selected: _filter == _OrdersViewFilter.completed,
                            onSelected: (_) => setState(
                              () => _filter = _OrdersViewFilter.completed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Center(child: Text(l10n.noOrdersTitle))),
                ],
              ),
            );
          }

          return SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: Text(l10n.statusInProgress),
                          selected: _filter == _OrdersViewFilter.active,
                          onSelected: (_) => setState(
                            () => _filter = _OrdersViewFilter.active,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: Text(l10n.statusCompleted),
                          selected: _filter == _OrdersViewFilter.completed,
                          onSelected: (_) => setState(
                            () => _filter = _OrdersViewFilter.completed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      final order = entry.value;
                      final key = entry.key;
                      final canModifyOrder =
                          canManageOrders &&
                          (!isTeamMode ||
                              appRole != AppRole.master ||
                              _canMasterAccessOrder(
                                order,
                                currentUid,
                                currentUserLabel,
                              ));

                      return Dismissible(
                        key: Key(key.toString()),
                        direction: canDeleteOrders
                            ? DismissDirection.endToStart
                            : DismissDirection.none,
                        confirmDismiss: (_) => ConfirmDialog.show(
                          context: context,
                          title: canDeleteOrders
                              ? l10n.deleteOrderTitle
                              : l10n.permissionDeniedTitle,
                          message: canDeleteOrders
                              ? l10n.deleteOrderMessage(
                                  order['car']?.toString() ?? '',
                                )
                              : l10n.permissionDeleteOrderDenied,
                          confirmText: canDeleteOrders
                              ? l10n.delete
                              : l10n.gotIt,
                          icon: canDeleteOrders
                              ? Icons.delete_forever
                              : Icons.block,
                        ),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          if (!canDeleteOrders) {
                            return;
                          }
                          final orderId = order['id']?.toString();
                          // Delete local photo files before removing the record.
                          _deleteOrderPhotos(order);
                          box.delete(key);
                          unawaited(
                            AppDataService.deleteOrderFromCloud(orderId),
                          );
                          unawaited(
                            OrderReminderService.cancelForOrder(orderId),
                          );
                          FlutterLocalNotificationsPlugin().cancel(0).ignore();
                          final messenger = ScaffoldMessenger.of(context);
                          messenger.clearSnackBars();
                          messenger.showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 4),
                              content: Text(
                                l10n.deletedOrderSnack(
                                  order['car']?.toString() ?? '',
                                ),
                              ),
                              action: SnackBarAction(
                                label: l10n.undo,
                                onPressed: () => box.put(key, order),
                              ),
                            ),
                          );
                        },
                        child: _OrderCard(
                          order: order,
                          orderKey: key,
                          currency: currency,
                          box: box,
                          canModifyOrder: canModifyOrder,
                          onClientTap: (clientName, clientId) =>
                              _navigateToClientDetails(
                                context,
                                clientName,
                                clientId,
                              ),
                          onEdit: (order) {
                            if (!canModifyOrder) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.permissionEditOrderDenied),
                                ),
                              );
                              return;
                            }
                            _editOrder(context, order);
                          },
                          onOpen: () {
                            if (!canModifyOrder) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.permissionEditOrderDenied),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailsScreen(
                                  orderData: Map<String, dynamic>.from(order),
                                  currency: currency,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: canManageOrders
            ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddJobScreen()),
              )
            : () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.permissionCreateOrderDenied)),
              ),
        icon: const Icon(Icons.add),
        label: Text(l10n.orderButton),
      ),
    );
  }

  void _navigateToClientDetails(
    BuildContext context,
    String clientName,
    String? clientId,
  ) {
    final clientBox = Hive.box(HiveBoxes.clients);
    dynamic clientMap;
    dynamic clientKey;

    if (clientId != null && clientId.isNotEmpty) {
      for (final key in clientBox.keys) {
        final raw = clientBox.get(key);
        if (raw is! Map) continue;
        if (raw['id']?.toString() == clientId) {
          clientMap = raw;
          clientKey = key;
          break;
        }
      }
    }

    if (clientMap == null) {
      for (final key in clientBox.keys) {
        final raw = clientBox.get(key);
        if (raw is! Map) continue;
        if (raw['name']?.toString() == clientName) {
          clientMap = raw;
          clientKey = key;
          break;
        }
      }
    }

    if (clientMap != null) {
      final client = Client.fromMap(clientMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ClientDetailsScreen(client: client, clientKey: clientKey),
        ),
      );
    }
  }

  void _editOrder(BuildContext context, dynamic orderData) {
    final order = Order.fromMap(orderData as Map);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddJobScreen(orderToEdit: order)),
    );
  }

  int _getStatusPriority(String? status) {
    final orderStatus = OrderStatus.fromName(status);
    switch (orderStatus) {
      case OrderStatus.scheduled:
        return 1;
      case OrderStatus.inProgress:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.paid:
        return 4;
      case OrderStatus.completed:
        return 5;
    }
  }

  bool _isCompletedStatus(String? status) {
    final parsed = OrderStatus.fromName(status);
    return parsed == OrderStatus.completed || parsed == OrderStatus.paid;
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;
  final dynamic orderKey;
  final String currency;
  final Box box;
  final bool canModifyOrder;
  final void Function(String, String?) onClientTap;
  final void Function(dynamic) onEdit;
  final VoidCallback onOpen;

  const _OrderCard({
    required this.order,
    required this.orderKey,
    required this.currency,
    required this.box,
    required this.canModifyOrder,
    required this.onClientTap,
    required this.onEdit,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = OrderStatus.fromName(order['status']?.toString());
    final isCompleted =
        status == OrderStatus.completed || status == OrderStatus.paid;

    return GestureDetector(
      onTap: onOpen,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['car'] ?? l10n.carLabel,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? Colors.grey : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => onClientTap(
                            order['client']?.toString() ?? '',
                            order['clientId']?.toString(),
                          ),
                          child: Text(
                            l10n.clientLabel(order['client']?.toString() ?? ''),
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        Text(
                          l10n.serviceLabel(
                            orderServicesSummary(order),
                            order['duration']?.toString() ?? '0',
                          ),
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        if ((order['assignedToName']
                                ?.toString()
                                .trim()
                                .isNotEmpty ??
                            false))
                          Text(
                            'Master: ${order['assignedToName']}',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _formatSchedule(order),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${order['price']} $currency',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _StatusChip(
                        status: status,
                        label: status.localizedLabel(l10n),
                      ),
                    ],
                  ),
                ],
              ),
              if (!isCompleted) ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatusButton(
                        label: l10n.edit,
                        color: AppColors.primary,
                        icon: Icons.edit,
                        onTap: canModifyOrder
                            ? () => onEdit(order)
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.permissionEditOrderDenied),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (status == OrderStatus.scheduled)
                      Expanded(
                        child: _StatusButton(
                          label: l10n.start,
                          color: AppColors.info,
                          icon: Icons.play_arrow,
                          onTap: canModifyOrder
                              ? () => _updateStatus(
                                  context,
                                  OrderStatus.inProgress.name,
                                )
                              : () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.permissionEditOrderDenied,
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    if (status == OrderStatus.inProgress)
                      Expanded(
                        child: _StatusButton(
                          label: l10n.markDone,
                          color: AppColors.success,
                          icon: Icons.check,
                          onTap: canModifyOrder
                              ? () => _updateStatus(
                                  context,
                                  OrderStatus.ready.name,
                                )
                              : () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.permissionEditOrderDenied,
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    if (status == OrderStatus.ready)
                      Expanded(
                        child: _StatusButton(
                          label: l10n.markPaid,
                          color: Colors.purple,
                          icon: Icons.payment,
                          onTap: canModifyOrder
                              ? () => _updateStatus(
                                  context,
                                  OrderStatus.paid.name,
                                )
                              : () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.permissionEditOrderDenied,
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatusButton(
                        label: l10n.edit,
                        color: Colors.grey,
                        icon: Icons.open_in_new,
                        onTap: onOpen,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _updateStatus(BuildContext context, String newStatus) {
    final l10n = AppLocalizations.of(context)!;
    final updatedOrder = Map<String, dynamic>.from(order);
    if ((updatedOrder['id']?.toString().isEmpty ?? true)) {
      updatedOrder['id'] = DateTime.now().microsecondsSinceEpoch.toString();
    }
    updatedOrder['status'] = newStatus;
    box.put(orderKey, updatedOrder);
    // Sync status change to Firestore
    AppDataService.syncOrderToCloud(updatedOrder).ignore();

    final orderId = updatedOrder['id']?.toString();
    if (newStatus == OrderStatus.completed.name ||
        newStatus == OrderStatus.paid.name) {
      OrderReminderService.cancelForOrder(orderId).ignore();
    }

    // Локальное уведомление
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'orders_channel',
      l10n.ordersChannelName,
      channelDescription: l10n.ordersChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_launcher_foreground',
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    final newStatusLabel = OrderStatus.fromName(newStatus).localizedLabel(l10n);

    FlutterLocalNotificationsPlugin().show(
      0,
      l10n.statusChangedTitle,
      l10n.statusChangedMessage(order['car']?.toString() ?? '', newStatusLabel),
      platformChannelSpecifics,
    );
  }

  String _formatSchedule(Map order) {
    final rawDate = order['scheduledDate'];
    final rawTime = order['scheduledTime']?.toString();

    String dateLabel = '--.--.----';
    if (rawDate is num) {
      final date = DateTime.fromMillisecondsSinceEpoch(rawDate.toInt());
      dateLabel = DateFormat('dd.MM.yyyy').format(date);
    }

    final timeLabel = (rawTime != null && rawTime.isNotEmpty)
        ? rawTime
        : '--:--';
    return '$dateLabel • $timeLabel';
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;
  final String label;

  const _StatusChip({required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getColor()),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _getColor(),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case OrderStatus.scheduled:
        return AppColors.info;
      case OrderStatus.inProgress:
        return AppColors.warning;
      case OrderStatus.ready:
        return AppColors.success;
      case OrderStatus.paid:
        return Colors.purple;
      case OrderStatus.completed:
        return Colors.grey;
    }
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }
}
