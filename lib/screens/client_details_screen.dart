import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/app_data_service.dart';
import '../core/access_guard.dart';
import '../core/order_services.dart';
import '../core/subscription_texts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../models/client.dart';
import 'add_client_screen.dart'; // Импортируем экран добавления/редактирования
import 'add_job_screen.dart';
import 'order_details_screen.dart';

class ClientDetailsScreen extends StatefulWidget {
  final Client client;
  final dynamic clientKey;

  const ClientDetailsScreen({
    super.key,
    required this.client,
    required this.clientKey,
  });

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  String _segmentLabel(AppLocalizations l10n, int ordersCount) {
    if (ordersCount >= 5) return l10n.crmSegmentLoyal;
    if (ordersCount >= 2) return l10n.crmSegmentReturning;
    if (ordersCount == 1) return l10n.crmSegmentNew;
    return l10n.orderHistoryEmpty;
  }

  bool _isAtRisk(DateTime? lastOrderDate) {
    if (lastOrderDate == null) return false;
    final days = DateTime.now().difference(lastOrderDate).inDays;
    return days >= 30 && days < 45;
  }

  bool _isInactive(DateTime? lastOrderDate) {
    if (lastOrderDate == null) return false;
    final days = DateTime.now().difference(lastOrderDate).inDays;
    return days >= 45;
  }

  String _formatDate(int? timestamp) {
    if (timestamp == null || timestamp <= 0) {
      return '-';
    }
    final d = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }

  void _openPhotoFullscreen(String photoPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CarPhotoViewerScreen(photoPath: photoPath),
      ),
    );
  }

  Widget _buildCarPhoto(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.directions_car, size: 56, color: Colors.grey),
      );
    }

    final isRemote =
        photoPath.startsWith('http://') || photoPath.startsWith('https://');
    final image = (kIsWeb || isRemote)
        ? Image.network(photoPath, fit: BoxFit.cover)
        : Image.file(
            File(photoPath),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: Color(0xFF2A2A2A),
              child: Icon(Icons.broken_image_outlined, color: Colors.white54),
            ),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(height: 180, width: double.infinity, child: image),
    );
  }

  Widget _buildCarPhotoThumb(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return Container(
        color: AppColors.surface,
        child: const Icon(Icons.directions_car, size: 34, color: Colors.grey),
      );
    }

    final isRemote =
        photoPath.startsWith('http://') || photoPath.startsWith('https://');
    final image = (kIsWeb || isRemote)
        ? Image.network(photoPath, fit: BoxFit.cover)
        : Image.file(
            File(photoPath),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: Color(0xFF2A2A2A),
              child: Icon(Icons.broken_image_outlined, color: Colors.white54),
            ),
          );

    return InkWell(
      onTap: () => _openPhotoFullscreen(photoPath),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.zoom_in, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarPhotoCard(String car, String? photoPath) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 100,
              width: 180,
              child: _buildCarPhotoThumb(photoPath),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            car,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _normalizePhone(String raw) {
    var digits = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.startsWith('00')) {
      digits = '+${digits.substring(2)}';
    }
    if (!digits.startsWith('+') && digits.isNotEmpty) {
      digits = '+$digits';
    }
    return digits;
  }

  Future<void> _launchCall(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.openCallFailed)),
      );
    }
  }

  Future<void> _launchSms(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'sms', path: phone);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.openWhatsAppFailed),
        ),
      );
    }
  }

  Future<bool> _launchReminderSms(
    BuildContext context,
    String phone, {
    required String clientName,
    required String? serviceName,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final service = (serviceName ?? '').trim().isNotEmpty
        ? serviceName!.trim()
        : l10n.serviceFieldLabel.toLowerCase();
    final body = l10n.crmReminderTemplate(clientName, service);
    final uri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{'body': body},
    );
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.openWhatsAppFailed),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _markReminderSent(Box box, dynamic clientKey) async {
    final raw = box.get(clientKey);
    if (raw is! Map) {
      return;
    }

    final updated = Map<String, dynamic>.from(raw)
      ..['lastReminderAt'] = DateTime.now().millisecondsSinceEpoch
      ..['lastReminderChannel'] = 'sms'
      ..['lastReminderType'] = 'single';

    await box.put(clientKey, updated);
    unawaited(AppDataService.syncClientToCloud(updated));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final oBox = Hive.box(HiveBoxes.orders);
    final cBox = Hive.box(HiveBoxes.clients);
    final settingsBox = Hive.box(HiveBoxes.settings);
    final currency = settingsBox.get('currency', defaultValue: '€').toString();

    return ValueListenableBuilder(
      valueListenable: cBox.listenable(),
      builder: (context, Box box, _) {
        // Читаем клиента по ключу, чтобы переименование не ломало экран деталей.
        final clientData = box.get(widget.clientKey);

        if (clientData == null) {
          return Scaffold(body: Center(child: Text(l10n.clientDeleted)));
        }

        final currentClientMap = Map<String, dynamic>.from(clientData as Map);
        final currentClient = Client.fromMap(currentClientMap);
        final currentClientId = currentClient.id?.toString();
        final lastReminderTs = (currentClientMap['lastReminderAt'] as num?)
            ?.toInt();
        final normalizedPhone = _normalizePhone(currentClient.phone ?? '');
        final hasPhone = normalizedPhone.isNotEmpty;
        final canManageBusinessData = AccessGuard.canManageOrdersAndClients();

        // Фильтруем заказы именно этого клиента
        final clientOrders =
            oBox.values.where((o) {
              if (o is! Map) return false;

              final orderClientId = o['clientId']?.toString();
              if (currentClientId != null && currentClientId.isNotEmpty) {
                if (orderClientId == currentClientId) return true;
                return orderClientId == null &&
                    o['client'] == currentClient.name;
              }

              return o['client'] == currentClient.name;
            }).toList()..sort((a, b) {
              final aDate = (a['scheduledDate'] as num?)?.toInt() ?? 0;
              final bDate = (b['scheduledDate'] as num?)?.toInt() ?? 0;
              return bDate.compareTo(aDate);
            });
        final segment = _segmentLabel(l10n, clientOrders.length);
        final lastOrderTs = clientOrders.isNotEmpty
            ? (clientOrders.first['scheduledDate'] as num?)?.toInt()
            : null;
        final lastOrderDate = lastOrderTs != null
            ? DateTime.fromMillisecondsSinceEpoch(lastOrderTs)
            : null;
        final atRisk = _isAtRisk(lastOrderDate);
        final inactive = _isInactive(lastOrderDate);
        final lastServiceName = clientOrders.isNotEmpty
            ? clientOrders.first['service']?.toString()
            : null;

        return Scaffold(
          appBar: AppBar(
            title: Text(currentClient.name),
            actions: [
              // КНОПКА РЕДАКТИРОВАНИЯ
              if (hasPhone)
                IconButton(
                  icon: const Icon(Icons.call_outlined),
                  tooltip: l10n.call,
                  onPressed: () => _launchCall(context, normalizedPhone),
                ),
              if (hasPhone)
                IconButton(
                  icon: const Icon(Icons.message_outlined),
                  tooltip: l10n.message,
                  onPressed: () => _launchSms(context, normalizedPhone),
                ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: canManageBusinessData
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddClientScreen(
                              clientToEdit: currentClient,
                              clientKey: widget.clientKey,
                            ),
                          ),
                        );
                      }
                    : () => AccessGuard.showDenied(
                        context,
                        message: l10n.permissionEditClientDenied,
                      ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // КАРТОЧКА ИНФОРМАЦИИ
              Card(
                elevation: 0,
                color: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentClient.cars.isNotEmpty) ...[
                        SizedBox(
                          height: 132,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentClient.cars.length,
                            separatorBuilder: (_, index) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final car = currentClient.cars[index];
                              return _buildCarPhotoCard(
                                car,
                                currentClient.photoForCar(car),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ] else ...[
                        _buildCarPhoto(currentClient.carPhotoPath),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            l10n.clientGarageTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: currentClient.cars
                            .map(
                              (car) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  car,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        Icons.history,
                        l10n.visits,
                        "${clientOrders.length}",
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.pie_chart_outline,
                        l10n.crmSegmentLabel,
                        segment,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.event_repeat_outlined,
                        l10n.crmLastVisitLabel,
                        _formatDate(lastOrderTs),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.sms_outlined,
                        l10n.crmReminderButton,
                        _formatDate(lastReminderTs),
                      ),
                      if (atRisk) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.warning_amber_rounded,
                          l10n.crmFilterAtRisk,
                          l10n.crmAtRiskLabel,
                        ),
                      ],
                      if (inactive) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.block_outlined,
                          l10n.crmFilterInactive,
                          l10n.inactiveClients,
                        ),
                      ],
                      if (currentClient.tags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.local_offer_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${l10n.crmTagsLabel}: ',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Expanded(
                              child: Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: currentClient.tags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.12,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.25,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if ((currentClient.notes ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.sticky_note_2_outlined,
                          l10n.orderNotesLabel,
                          currentClient.notes!.trim(),
                        ),
                      ],
                      if (hasPhone) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _launchCall(context, normalizedPhone),
                                icon: const Icon(Icons.call_outlined),
                                label: Text(l10n.call),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    _launchSms(context, normalizedPhone),
                                icon: const Icon(Icons.message_outlined),
                                label: Text(l10n.message),
                              ),
                            ),
                          ],
                        ),
                        if (atRisk || inactive) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () async {
                                if (!AccessGuard.canUseCrmCampaigns()) {
                                  await AccessGuard.showUpgradePrompt(
                                    context,
                                    title: SubscriptionTexts.crmProTitle(
                                      context,
                                    ),
                                    message: SubscriptionTexts.crmProMessage(
                                      context,
                                    ),
                                    requiredPlan: AppPlan.pro,
                                  );
                                  return;
                                }

                                final opened = await _launchReminderSms(
                                  context,
                                  normalizedPhone,
                                  clientName: currentClient.name,
                                  serviceName: lastServiceName,
                                );
                                if (!opened) {
                                  return;
                                }
                                await _markReminderSent(box, widget.clientKey);
                              },
                              icon: const Icon(Icons.sms_outlined),
                              label: Text(l10n.crmReminderButton),
                            ),
                          ),
                        ],
                      ],
                      if (canManageBusinessData) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddJobScreen(
                                    initialClientName: currentClient.name,
                                    initialClientId: currentClientId,
                                    initialCar: currentClient.cars.isNotEmpty
                                        ? currentClient.cars.first
                                        : null,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_task_outlined),
                            label: Text(l10n.newOrder),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                l10n.orderHistoryTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (clientOrders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      l10n.orderHistoryEmpty,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...clientOrders.map((orderData) {
                  final status = orderData['status'];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(
                              orderData: Map<String, dynamic>.from(orderData),
                              currency: currency,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        orderData['car'] ?? l10n.carLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${orderServicesSummary(orderData)} • ${orderData['price']} $currency",
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatStatus(status, l10n),
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String _formatStatus(String? status, AppLocalizations l10n) {
    if (status == 'completed' || status == 'paid') {
      return l10n.statusCompleted.toUpperCase();
    }
    return l10n.statusInProgress.toUpperCase();
  }

  Color _getStatusColor(String? status) {
    if (status == 'completed' || status == 'paid') return Colors.green;
    return Colors.orange;
  }
}

class _CarPhotoViewerScreen extends StatelessWidget {
  final String photoPath;

  const _CarPhotoViewerScreen({required this.photoPath});

  @override
  Widget build(BuildContext context) {
    final isRemote =
        photoPath.startsWith('http://') || photoPath.startsWith('https://');
    final image = (kIsWeb || isRemote)
        ? Image.network(photoPath, fit: BoxFit.contain)
        : Image.file(
            File(photoPath),
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 64,
            ),
          );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: InteractiveViewer(minScale: 0.8, maxScale: 4, child: image),
      ),
    );
  }
}
