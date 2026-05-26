import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/access_guard.dart';
import '../core/app_data_service.dart';
import '../core/constants.dart';
import '../core/subscription_texts.dart';
import '../models/client.dart';
import '../widgets/confirm_dialog.dart';
import 'add_client_screen.dart';
import 'client_details_screen.dart';
import 'crm_campaign_history_screen.dart';

enum _ClientSort { nameAsc, nameDesc, newest }

enum _ClientCrmFilter { all, vip, atRisk, inactive }

class _ClientOrderStats {
  final int ordersCount;
  final DateTime? lastOrderDate;

  const _ClientOrderStats({required this.ordersCount, this.lastOrderDate});
}

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  _ClientSort _sort = _ClientSort.nameAsc;
  _ClientCrmFilter _crmFilter = _ClientCrmFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  Widget _buildClientAvatar(Client client) {
    final String? photoPath;
    if (client.cars.isNotEmpty) {
      final first = client.cars.first;
      photoPath = client.photoForCar(first);
    } else {
      photoPath = client.carPhotoPath;
    }
    if (photoPath != null && photoPath.isNotEmpty) {
      final isRemote =
          photoPath.startsWith('http://') || photoPath.startsWith('https://');
      final image = (kIsWeb || isRemote)
          ? Image.network(photoPath, fit: BoxFit.cover)
          : Image.file(
              File(photoPath),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFF2A2A2A),
                child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 18),
              ),
            );
      return CircleAvatar(
        radius: 22,
        backgroundColor: Colors.transparent,
        child: ClipOval(child: SizedBox(width: 44, height: 44, child: image)),
      );
    }

    return CircleAvatar(
      backgroundColor: _avatarColor(client.name),
      child: Text(
        client.name[0].toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _avatarColor(String key) {
    // Простое хеширование имени клиента для генерации постоянного цвета
    final hash = key.codeUnits.fold<int>(0, (acc, code) => acc + code);
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    return colors[hash % colors.length];
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

  Future<void> _openBulkReminderComposer(
    BuildContext context,
    List<MapEntry<dynamic, Client>> filtered,
  ) async {
    if (!AccessGuard.canUseCrmCampaigns()) {
      await AccessGuard.showUpgradePrompt(
        context,
        title: SubscriptionTexts.crmProTitle(context),
        message: SubscriptionTexts.crmProMessage(context),
        requiredPlan: AppPlan.pro,
      );
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final candidates = filtered
        .where((entry) => _normalizePhone(entry.value.phone ?? '').isNotEmpty)
        .toList();

    if (candidates.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.crmBulkReminderEmpty)));
      return;
    }

    final selected = <dynamic>{for (final entry in candidates) entry.key};

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return SafeArea(
              top: false,
              child: SizedBox(
                height: MediaQuery.of(sheetContext).size.height * 0.72,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.crmBulkReminderTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                if (selected.length == candidates.length) {
                                  selected.clear();
                                } else {
                                  selected
                                    ..clear()
                                    ..addAll(candidates.map((e) => e.key));
                                }
                              });
                            },
                            child: Text(l10n.crmBulkReminderToggleAll),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: candidates.length,
                        itemBuilder: (context, index) {
                          final entry = candidates[index];
                          final client = entry.value;
                          final normalizedPhone = _normalizePhone(
                            client.phone ?? '',
                          );
                          final checked = selected.contains(entry.key);

                          return CheckboxListTile(
                            value: checked,
                            onChanged: (value) {
                              setSheetState(() {
                                if (value == true) {
                                  selected.add(entry.key);
                                } else {
                                  selected.remove(entry.key);
                                }
                              });
                            },
                            title: Text(client.name),
                            subtitle: Text(normalizedPhone),
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: selected.isEmpty
                              ? null
                              : () async {
                                  final phones = <String>{};
                                  for (final entry in candidates) {
                                    if (!selected.contains(entry.key)) continue;
                                    final phone = _normalizePhone(
                                      entry.value.phone ?? '',
                                    );
                                    if (phone.isNotEmpty) {
                                      phones.add(phone);
                                    }
                                  }

                                  if (phones.isEmpty) {
                                    return;
                                  }

                                  final uri = Uri(
                                    scheme: 'sms',
                                    path: phones.join(','),
                                    queryParameters: {
                                      'body': l10n.crmBulkReminderTemplate,
                                    },
                                  );

                                  final opened = await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                  if (opened) {
                                    await _markBulkReminderSent(
                                      candidates,
                                      selected,
                                    );
                                  }
                                  if (sheetContext.mounted) {
                                    Navigator.pop(sheetContext);
                                  }
                                  if (!opened && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.openWhatsAppFailed),
                                      ),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.sms_outlined),
                          label: Text(l10n.crmBulkReminderSendSelected),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _markBulkReminderSent(
    List<MapEntry<dynamic, Client>> candidates,
    Set<dynamic> selectedKeys,
  ) async {
    final clientsBox = Hive.box(HiveBoxes.clients);
    final settingsBox = Hive.box(HiveBoxes.settings);
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    var sentCount = 0;

    for (final entry in candidates) {
      if (!selectedKeys.contains(entry.key)) {
        continue;
      }

      final raw = clientsBox.get(entry.key);
      if (raw is! Map) {
        continue;
      }

      final updated = Map<String, dynamic>.from(raw)
        ..['lastReminderAt'] = nowMs
        ..['lastReminderChannel'] = 'sms'
        ..['lastReminderType'] = 'bulk';

      await clientsBox.put(entry.key, updated);
      unawaited(AppDataService.syncClientToCloud(updated));
      sentCount += 1;
    }

    await settingsBox.put('crmLastCampaignAt', nowMs);
    await settingsBox.put('crmLastCampaignCount', sentCount);
  }

  bool _hasVipTag(Client client) {
    return client.tags.any((tag) => tag.trim().toLowerCase() == 'vip');
  }

  _ClientOrderStats _buildClientStats(Client client, Box ordersBox) {
    final clientId = client.id?.trim();
    var ordersCount = 0;
    DateTime? lastOrderDate;

    for (final raw in ordersBox.values) {
      if (raw is! Map) continue;

      final orderClientId = raw['clientId']?.toString().trim();
      final orderClientName = raw['client']?.toString();

      final idMatch =
          clientId != null &&
          clientId.isNotEmpty &&
          orderClientId != null &&
          orderClientId == clientId;
      final legacyNameMatch =
          (orderClientId == null || orderClientId.isEmpty) &&
          orderClientName == client.name;

      if (!idMatch && !legacyNameMatch) continue;

      ordersCount += 1;
      final rawDate = (raw['scheduledDate'] as num?)?.toInt();
      if (rawDate == null) continue;
      final orderDate = DateTime.fromMillisecondsSinceEpoch(rawDate);
      if (lastOrderDate == null || orderDate.isAfter(lastOrderDate)) {
        lastOrderDate = orderDate;
      }
    }

    return _ClientOrderStats(
      ordersCount: ordersCount,
      lastOrderDate: lastOrderDate,
    );
  }

  bool _isInactive(_ClientOrderStats stats) {
    final last = stats.lastOrderDate;
    if (last == null) return false;
    final days = DateTime.now().difference(last).inDays;
    return days >= 45;
  }

  bool _isAtRisk(_ClientOrderStats stats) {
    final last = stats.lastOrderDate;
    if (last == null) return false;
    final days = DateTime.now().difference(last).inDays;
    return days >= 30 && days < 45;
  }

  String _segmentLabel(AppLocalizations l10n, _ClientOrderStats stats) {
    if (stats.ordersCount >= 5) return l10n.crmSegmentLoyal;
    if (stats.ordersCount >= 2) return l10n.crmSegmentReturning;
    if (stats.ordersCount == 1) return l10n.crmSegmentNew;
    return l10n.orderHistoryEmpty;
  }

  bool _passesCrmFilter(
    Client client,
    _ClientOrderStats stats,
    _ClientCrmFilter filter,
  ) {
    switch (filter) {
      case _ClientCrmFilter.all:
        return true;
      case _ClientCrmFilter.vip:
        return _hasVipTag(client);
      case _ClientCrmFilter.atRisk:
        return _isAtRisk(stats);
      case _ClientCrmFilter.inactive:
        return _isInactive(stats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cBox = Hive.box(HiveBoxes.clients);
    final canManageClients = AccessGuard.canManageOrdersAndClients();
    final canDeleteClients = AccessGuard.canManageBusinessData();
    final canUseCrmCampaigns = AccessGuard.canUseCrmCampaigns();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.navClients),
        actions: [
          IconButton(
            tooltip: l10n.orderHistoryTitle,
            icon: const Icon(Icons.history),
            onPressed: () {
              if (!canUseCrmCampaigns) {
                AccessGuard.showUpgradePrompt(
                  context,
                  title: SubscriptionTexts.crmProTitle(context),
                  message: SubscriptionTexts.crmProMessage(context),
                  requiredPlan: AppPlan.pro,
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CrmCampaignHistoryScreen(),
                ),
              );
            },
          ),
          PopupMenuButton<_ClientSort>(
            tooltip: l10n.sortTooltip,
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (value) => setState(() => _sort = value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _ClientSort.nameAsc,
                child: Text(l10n.sortByNameAsc),
              ),
              PopupMenuItem(
                value: _ClientSort.nameDesc,
                child: Text(l10n.sortByNameDesc),
              ),
              PopupMenuItem(
                value: _ClientSort.newest,
                child: Text(l10n.sortByNewest),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchClientsHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: cBox.listenable(),
        builder: (context, Box box, _) {
          return ValueListenableBuilder(
            valueListenable: Hive.box(HiveBoxes.orders).listenable(),
            builder: (context, Box ordersBox, child) {
              final entries = box
                  .toMap()
                  .entries
                  .map((e) => MapEntry(e.key, Client.fromMap(e.value as Map)))
                  .toList();

              // Фильтр поиска
              final filtered = entries.where((entry) {
                final client = entry.value;
                final stats = _buildClientStats(client, ordersBox);
                if (!_passesCrmFilter(client, stats, _crmFilter)) {
                  return false;
                }

                final query = _searchQuery;
                if (query.isEmpty) return true;

                final nameMatch = client.name.toLowerCase().contains(query);
                final carMatch = client.cars.any(
                  (car) => car.toLowerCase().contains(query),
                );
                final phoneMatch = (client.phone ?? '').toLowerCase().contains(
                  query,
                );
                final notesMatch = (client.notes ?? '').toLowerCase().contains(
                  query,
                );
                final tagsMatch = client.tags.any(
                  (tag) => tag.toLowerCase().contains(query),
                );

                return nameMatch ||
                    carMatch ||
                    phoneMatch ||
                    notesMatch ||
                    tagsMatch;
              }).toList();

              // Сортировка списка
              filtered.sort((a, b) {
                final aName = a.value.name.toLowerCase();
                final bName = b.value.name.toLowerCase();
                switch (_sort) {
                  case _ClientSort.nameAsc:
                    return aName.compareTo(bName);
                  case _ClientSort.nameDesc:
                    return bName.compareTo(aName);
                  case _ClientSort.newest:
                    final aDate =
                        a.value.createdAt?.millisecondsSinceEpoch ?? 0;
                    final bDate =
                        b.value.createdAt?.millisecondsSinceEpoch ?? 0;
                    return bDate.compareTo(aDate);
                }
              });

              if (filtered.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: Text(l10n.crmFilterAll),
                              selected: _crmFilter == _ClientCrmFilter.all,
                              onSelected: (_) => setState(
                                () => _crmFilter = _ClientCrmFilter.all,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(l10n.crmFilterVip),
                              selected: _crmFilter == _ClientCrmFilter.vip,
                              onSelected: (_) => setState(
                                () => _crmFilter = _ClientCrmFilter.vip,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(l10n.crmFilterAtRisk),
                              selected: _crmFilter == _ClientCrmFilter.atRisk,
                              onSelected: (_) => setState(
                                () => _crmFilter = _ClientCrmFilter.atRisk,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: Text(l10n.crmFilterInactive),
                              selected: _crmFilter == _ClientCrmFilter.inactive,
                              onSelected: (_) => setState(
                                () => _crmFilter = _ClientCrmFilter.inactive,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.clientsNotFound,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: canManageClients
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
                              icon: const Icon(Icons.person_add),
                              label: Text(l10n.newClient),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.crmFilterAll),
                            selected: _crmFilter == _ClientCrmFilter.all,
                            onSelected: (_) => setState(
                              () => _crmFilter = _ClientCrmFilter.all,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.crmFilterVip),
                            selected: _crmFilter == _ClientCrmFilter.vip,
                            onSelected: (_) => setState(
                              () => _crmFilter = _ClientCrmFilter.vip,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.crmFilterAtRisk),
                            selected: _crmFilter == _ClientCrmFilter.atRisk,
                            onSelected: (_) => setState(
                              () => _crmFilter = _ClientCrmFilter.atRisk,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.crmFilterInactive),
                            selected: _crmFilter == _ClientCrmFilter.inactive,
                            onSelected: (_) => setState(
                              () => _crmFilter = _ClientCrmFilter.inactive,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _openBulkReminderComposer(context, filtered),
                        icon: const Icon(Icons.campaign_outlined),
                        label: Text(l10n.crmBulkReminderButton),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final entry = filtered[index];
                        final client = entry.value;
                        final clientKey = entry.key;
                        final firstCar = client.cars.isNotEmpty
                            ? client.cars.first
                            : null;
                        final normalizedPhone = _normalizePhone(
                          client.phone ?? '',
                        );
                        final hasPhone = normalizedPhone.isNotEmpty;
                        final stats = _buildClientStats(client, ordersBox);
                        final segment = _segmentLabel(l10n, stats);

                        return Dismissible(
                          key: ValueKey(clientKey),
                          direction: canDeleteClients
                              ? DismissDirection.endToStart
                              : DismissDirection.none,
                          confirmDismiss: (_) async {
                            if (!canDeleteClients) {
                              if (!context.mounted) return false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.permissionDeleteClientDenied,
                                  ),
                                ),
                              );
                              return false;
                            }

                            final confirmed = await ConfirmDialog.show(
                              context: context,
                              title: l10n.deleteOrderTitle,
                              message: l10n.deleteOrderMessage(client.name),
                              confirmText: l10n.delete,
                              cancelText: l10n.cancel,
                              icon: Icons.delete_forever,
                            );
                            return confirmed ?? false;
                          },
                          onDismissed: (_) {
                            if (canDeleteClients) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              // Remove from Hive + cloud
                              unawaited(
                                AppDataService.deleteClientFromCloud(client.id),
                              );
                              cBox.delete(clientKey);
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: _buildClientAvatar(client),
                              title: Text(
                                client.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    firstCar ??
                                        ((client.notes ?? '').isNotEmpty
                                            ? client.notes!
                                            : l10n.noCars),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      _InlineBadge(label: segment),
                                      if (_hasVipTag(client))
                                        _InlineBadge(label: l10n.crmFilterVip),
                                      if (_isAtRisk(stats))
                                        _InlineBadge(
                                          label: l10n.crmFilterAtRisk,
                                        ),
                                      if (_isInactive(stats))
                                        _InlineBadge(
                                          label: l10n.crmFilterInactive,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (hasPhone)
                                    IconButton(
                                      tooltip: l10n.call,
                                      icon: const Icon(
                                        Icons.call_outlined,
                                        size: 20,
                                      ),
                                      onPressed: () =>
                                          _launchCall(context, normalizedPhone),
                                    ),
                                  if (hasPhone)
                                    IconButton(
                                      tooltip: l10n.message,
                                      icon: const Icon(
                                        Icons.message_outlined,
                                        size: 20,
                                      ),
                                      onPressed: () =>
                                          _launchSms(context, normalizedPhone),
                                    ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ClientDetailsScreen(
                                      client: client,
                                      clientKey: clientKey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: canManageClients
            ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddClientScreen()),
              )
            : () => AccessGuard.showDenied(
                context,
                message: l10n.permissionCreateClientDenied,
              ),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class _InlineBadge extends StatelessWidget {
  final String label;

  const _InlineBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.white70),
      ),
    );
  }
}
