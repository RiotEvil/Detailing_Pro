import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/app_data_service.dart';
import '../core/constants.dart';
import '../widgets/empty_state.dart';

String _inventoryTypeLabel(AppLocalizations l10n, InventoryItemType type) {
  switch (type) {
    case InventoryItemType.chemistry:
      return l10n.inventoryTypeChemistry;
    case InventoryItemType.consumable:
      return l10n.inventoryTypeConsumable;
    case InventoryItemType.accessory:
      return l10n.inventoryTypeAccessory;
    case InventoryItemType.equipment:
      return l10n.inventoryTypeEquipment;
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _showAll = false;
  bool _showLowStockOnly = false;
  InventoryItemType? _selectedTypeFilter;
  bool _isSyncingLowStockNotifications = false;

  @override
  Widget build(BuildContext context) {
    // Используем синхронное получение бокса, так как он открыт в main.dart
    final Box inventoryBox = Hive.box(HiveBoxes.inventory);
    final settingsBox = Hive.box(HiveBoxes.settings);
    final l10n = AppLocalizations.of(context)!;
    final businessMode = BusinessMode.fromStorage(
      settingsBox.get('businessMode')?.toString(),
    );
    final appRole = AppRole.fromStorage(
      settingsBox.get('appRole')?.toString(),
      mode: businessMode,
    );
    final canManageBusinessData = appRole.canManageBusinessData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ValueListenableBuilder(
        valueListenable: inventoryBox.listenable(),
        builder: (context, Box box, _) {
          final entries = box.keys
              .map((key) {
                final dynamic rawItem = box.get(key);
                if (rawItem is! Map) return null;
                final item = Map<String, dynamic>.from(rawItem);
                return MapEntry<dynamic, Map<String, dynamic>>(key, item);
              })
              .whereType<MapEntry<dynamic, Map<String, dynamic>>>()
              .toList();

          final lowStockEntries = entries
              .where((entry) => _isLowStock(entry.value))
              .toList();

          if (canManageBusinessData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _syncLowStockNotifications(settingsBox, lowStockEntries);
            });
          }

          if (box.isEmpty) {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: l10n.inventoryEmptyTitle,
              subtitle: l10n.inventoryFirstItemHint,
            );
          }

          // Группировка по категориям с защитой данных
          final Map<String, List<MapEntry>> grouped = {};
          for (final entry in entries) {
            final key = entry.key;
            final item = entry.value;
            final itemType = InventoryItemType.fromStorage(
              item['itemType']?.toString(),
            );
            final category = item['category']?.toString() ?? l10n.otherCategory;

            if (_selectedTypeFilter != null &&
                itemType != _selectedTypeFilter) {
              continue;
            }

            if (_showLowStockOnly && !_isLowStock(item)) {
              continue;
            }

            final groupKey =
                '${_inventoryTypeLabel(l10n, itemType)} • $category';

            grouped.putIfAbsent(groupKey, () => []);
            grouped[groupKey]!.add(MapEntry(key, item));
          }

          final categories = grouped.entries.toList();
          final displayedCategories = _showAll
              ? categories
              : categories.take(5).toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _InventoryAlertHeader(
                lowStockEntries: lowStockEntries,
                selectedTypeFilter: _selectedTypeFilter,
                showLowStockOnly: _showLowStockOnly,
                onTypeSelected: (type) {
                  setState(() {
                    _selectedTypeFilter = type;
                    _showAll = false;
                  });
                },
                onLowStockToggle: (value) {
                  setState(() {
                    _showLowStockOnly = value;
                    _showAll = false;
                  });
                },
              ),
              if (categories.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.inventoryFilteredEmpty,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ...displayedCategories.map((categoryEntry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Text(
                        categoryEntry.key.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...categoryEntry.value.map(
                      (entry) => _InventoryItem(
                        itemKey: entry.key,
                        item: entry.value,
                        box: box,
                        canManageBusinessData: canManageBusinessData,
                        onAddStock: () =>
                            _addStock(context, box, entry.key, entry.value),
                        onEditItem: () =>
                            _editItem(context, box, entry.key, entry.value),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
              if (categories.length > 5 && !_showAll)
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _showAll = true),
                    child: Text(l10n.showAllCategories),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: canManageBusinessData
            ? () => _addInventoryItem(context)
            : () => _showAccessDenied(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.inventoryItemLabel),
      ),
    );
  }

  void _showAccessDenied(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.permissionModifyInventoryDenied)),
    );
  }

  bool _isLowStock(Map item) {
    final amount = (item['amount'] as num?)?.toInt() ?? 0;
    final minStock = (item['minStock'] as num?)?.toInt() ?? 0;
    return minStock > 0 && amount <= minStock;
  }

  String _inventoryEntryId(dynamic key, Map item) {
    final id = item['id']?.toString();
    if (id != null && id.isNotEmpty) {
      return id;
    }
    return key.toString();
  }

  Future<void> _syncLowStockNotifications(
    Box settingsBox,
    List<MapEntry<dynamic, Map<String, dynamic>>> lowStockEntries,
  ) async {
    if (_isSyncingLowStockNotifications) {
      return;
    }

    _isSyncingLowStockNotifications = true;
    try {
      final stored = ((settingsBox.get('lowStockNotifiedIds') as List?) ?? [])
          .map((e) => e.toString())
          .toSet();
      final current = lowStockEntries
          .map((entry) => _inventoryEntryId(entry.key, entry.value))
          .toSet();
      final newlyLow = lowStockEntries.where((entry) {
        final id = _inventoryEntryId(entry.key, entry.value);
        return !stored.contains(id);
      }).toList();

      if (newlyLow.isNotEmpty) {
        final l10n = AppLocalizations.of(context)!;
        final itemNames = newlyLow
            .take(3)
            .map(
              (entry) =>
                  entry.value['name']?.toString() ?? l10n.inventoryItemLabel,
            )
            .join(', ');
        final extraCount = newlyLow.length > 3
            ? l10n.inventoryLowStockMore(newlyLow.length - 3)
            : '';

        await FlutterLocalNotificationsPlugin().show(
          1001,
          l10n.inventoryLowStockTitle,
          l10n.inventoryLowStockBody('$itemNames$extraCount'),
          NotificationDetails(
            android: AndroidNotificationDetails(
              'inventory_alerts',
              l10n.inventoryNotificationsChannelName,
              channelDescription: l10n.inventoryNotificationsChannelDescription,
              importance: Importance.max,
              priority: Priority.high,
              icon: 'ic_launcher_foreground',
            ),
          ),
        );
      }

      await settingsBox.put('lowStockNotifiedIds', current.toList());
    } finally {
      _isSyncingLowStockNotifications = false;
    }
  }

  void _addStock(BuildContext context, Box box, dynamic key, Map item) {
    final l10n = AppLocalizations.of(context)!;
    final unit = InventoryUnit.fromStorage(item['unit']?.toString());
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.replenishItemTitle(item['name']?.toString() ?? '')),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.howManyToAdd,
            suffixText: unit.label,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final addAmount = int.tryParse(controller.text) ?? 0;
              if (addAmount > 0) {
                final updated = Map<String, dynamic>.from(item);
                final currentAmount = (item['amount'] as num?)?.toInt() ?? 0;
                updated['amount'] = currentAmount + addAmount;
                box.put(key, updated);
                // Sync restock to Firestore
                AppDataService.syncInventoryItemToCloud(
                  Map<String, dynamic>.from(updated),
                ).ignore();
              }
              Navigator.pop(ctx);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _editItem(BuildContext context, Box box, dynamic key, Map item) {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(
      text: item['name']?.toString() ?? '',
    );
    final brandCtrl = TextEditingController(
      text: item['brand']?.toString() ?? '',
    );
    final categoryCtrl = TextEditingController(
      text: item['category']?.toString() ?? '',
    );
    final amountCtrl = TextEditingController(
      text: ((item['amount'] as num?)?.toInt() ?? 0).toString(),
    );
    final minStockCtrl = TextEditingController(
      text: ((item['minStock'] as num?)?.toInt() ?? 0).toString(),
    );
    final locationCtrl = TextEditingController(
      text: item['location']?.toString() ?? '',
    );
    final usageCtrl = TextEditingController(
      text: item['usage']?.toString() ?? '',
    );
    var selectedType = InventoryItemType.fromStorage(
      item['itemType']?.toString(),
    );
    var selectedUnit = InventoryUnit.fromStorage(item['unit']?.toString());

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.inventoryEditItemTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<InventoryItemType>(
                  initialValue: selectedType,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryItemTypeLabel,
                  ),
                  items: InventoryItemType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_inventoryTypeLabel(l10n, type)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      selectedType = value;
                    });
                  },
                ),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: l10n.nameLabel),
                ),
                TextField(
                  controller: brandCtrl,
                  decoration: InputDecoration(labelText: l10n.brandLabel),
                ),
                TextField(
                  controller: categoryCtrl,
                  decoration: InputDecoration(labelText: l10n.categoryLabel),
                ),
                DropdownButtonFormField<InventoryUnit>(
                  initialValue: selectedUnit,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryUnitLabel,
                  ),
                  items: InventoryUnit.values
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      selectedUnit = value;
                    });
                  },
                ),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryCurrentStockLabel,
                  ),
                ),
                TextField(
                  controller: minStockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryMinStockLabel,
                  ),
                ),
                TextField(
                  controller: locationCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryLocationLabel,
                  ),
                ),
                TextField(
                  controller: usageCtrl,
                  minLines: 2,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryUsageLabel,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final updated = Map<String, dynamic>.from(item);
                updated['itemType'] = selectedType.name;
                updated['name'] = nameCtrl.text.trim();
                updated['brand'] = brandCtrl.text.trim();
                updated['category'] = categoryCtrl.text.trim().isEmpty
                    ? l10n.otherCategory
                    : categoryCtrl.text.trim();
                updated['unit'] = selectedUnit.label;
                updated['amount'] = int.tryParse(amountCtrl.text) ?? 0;
                updated['minStock'] = int.tryParse(minStockCtrl.text) ?? 0;
                updated['location'] = locationCtrl.text.trim();
                updated['usage'] = usageCtrl.text.trim();
                box.put(key, updated);
                // Sync edit to Firestore
                AppDataService.syncInventoryItemToCloud(
                  Map<String, dynamic>.from(updated),
                ).ignore();
                Navigator.pop(ctx);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _addInventoryItem(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final catCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final minStockCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final usageCtrl = TextEditingController();
    var selectedType = InventoryItemType.chemistry;
    var selectedUnit = InventoryUnit.ml;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.inventoryNewItemTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<InventoryItemType>(
                  initialValue: selectedType,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryItemTypeLabel,
                  ),
                  items: InventoryItemType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_inventoryTypeLabel(l10n, type)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      selectedType = value;
                      selectedUnit = value.defaultUnit;
                    });
                  },
                ),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: l10n.nameLabel),
                ),
                TextField(
                  controller: brandCtrl,
                  decoration: InputDecoration(labelText: l10n.brandLabel),
                ),
                TextField(
                  controller: catCtrl,
                  decoration: InputDecoration(labelText: l10n.categoryLabel),
                ),
                DropdownButtonFormField<InventoryUnit>(
                  initialValue: selectedUnit,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryUnitLabel,
                  ),
                  items: InventoryUnit.values
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      selectedUnit = value;
                    });
                  },
                ),
                TextField(
                  controller: amountCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryCurrentStockLabel,
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: minStockCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryMinStockLabel,
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: locationCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryLocationLabel,
                  ),
                ),
                TextField(
                  controller: usageCtrl,
                  minLines: 2,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.inventoryUsageLabel,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  final itemId = DateTime.now().microsecondsSinceEpoch
                      .toString();
                  final newItem = {
                    'id': itemId,
                    'name': nameCtrl.text.trim(),
                    'brand': brandCtrl.text.trim(),
                    'itemType': selectedType.name,
                    'category': catCtrl.text.trim().isEmpty
                        ? l10n.otherCategory
                        : catCtrl.text.trim(),
                    'amount': int.tryParse(amountCtrl.text) ?? 0,
                    'minStock': int.tryParse(minStockCtrl.text) ?? 0,
                    'location': locationCtrl.text.trim(),
                    'usage': usageCtrl.text.trim(),
                    'unit': selectedUnit.label,
                  };
                  Hive.box(HiveBoxes.inventory).add(newItem);
                  // Sync new item to Firestore
                  AppDataService.syncInventoryItemToCloud(
                    Map<String, dynamic>.from(newItem),
                  ).ignore();
                }
                Navigator.pop(ctx);
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryAlertHeader extends StatelessWidget {
  final List<MapEntry<dynamic, Map<String, dynamic>>> lowStockEntries;
  final InventoryItemType? selectedTypeFilter;
  final bool showLowStockOnly;
  final ValueChanged<InventoryItemType?> onTypeSelected;
  final ValueChanged<bool> onLowStockToggle;

  const _InventoryAlertHeader({
    required this.lowStockEntries,
    required this.selectedTypeFilter,
    required this.showLowStockOnly,
    required this.onTypeSelected,
    required this.onLowStockToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        if (lowStockEntries.isNotEmpty)
          Card(
            color: AppColors.error.withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.inventoryLowStockCount(lowStockEntries.length),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...lowStockEntries.take(4).map((entry) {
                    final item = entry.value;
                    final amount = (item['amount'] as num?)?.toInt() ?? 0;
                    final minStock = (item['minStock'] as num?)?.toInt() ?? 0;
                    final unit = InventoryUnit.fromStorage(
                      item['unit']?.toString(),
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        l10n.inventoryLowStockItemLine(
                          item['name']?.toString() ?? l10n.inventoryItemLabel,
                          amount,
                          unit.label,
                          minStock,
                        ),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: Text(l10n.inventoryAllTypes),
                selected: selectedTypeFilter == null,
                onSelected: (_) => onTypeSelected(null),
              ),
              ...InventoryItemType.values.map(
                (type) => ChoiceChip(
                  label: Text(_inventoryTypeLabel(l10n, type)),
                  selected: selectedTypeFilter == type,
                  onSelected: (_) => onTypeSelected(type),
                ),
              ),
              FilterChip(
                label: Text(l10n.inventoryBelowMin),
                selected: showLowStockOnly,
                onSelected: onLowStockToggle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _InventoryItem extends StatelessWidget {
  final dynamic itemKey;
  final Map item;
  final Box box;
  final bool canManageBusinessData;
  final VoidCallback onAddStock;
  final VoidCallback onEditItem;

  const _InventoryItem({
    required this.itemKey,
    required this.item,
    required this.box,
    required this.canManageBusinessData,
    required this.onAddStock,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amount = (item['amount'] as num?)?.toInt() ?? 0;
    final minStock = (item['minStock'] as num?)?.toInt() ?? 0;
    final itemType = InventoryItemType.fromStorage(
      item['itemType']?.toString(),
    );
    final unit = InventoryUnit.fromStorage(item['unit']?.toString());

    final baseline = minStock > 0 ? minStock * 3 : (amount > 0 ? amount : 1);
    final double percent = (amount / baseline).clamp(0.0, 1.0);

    // Цвет меняется от остатка
    Color progressColor = Colors.green;
    if (minStock > 0 && amount <= minStock) {
      progressColor = AppColors.error;
    } else if (percent < 0.5) {
      progressColor = Colors.orange;
    }

    return Dismissible(
      key: Key(itemKey.toString()),
      direction: canManageBusinessData
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        if (canManageBusinessData) {
          final itemId = item['id']?.toString();
          box.delete(itemKey);
          AppDataService.deleteInventoryFromCloud(itemId).ignore();
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ExpansionTile(
          leading: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percent,
                backgroundColor: Colors.white10,
                color: progressColor,
                strokeWidth: 3,
              ),
              Icon(itemType.icon, color: progressColor, size: 16),
            ],
          ),
          title: Text(
            item['name'] ?? l10n.unnamedItem,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            [
              item['brand']?.toString() ?? '',
              _inventoryTypeLabel(l10n, itemType),
              if ((item['location']?.toString() ?? '').isNotEmpty)
                item['location'].toString(),
            ].where((part) => part.isNotEmpty).join(' • '),
          ),
          trailing: Text(
            '$amount ${unit.label}',
            style: TextStyle(
              color: progressColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 360;

                  final addButton = OutlinedButton.icon(
                    onPressed: canManageBusinessData
                        ? onAddStock
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.permissionEditInventoryStockDenied,
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.add),
                    label: Text(
                      l10n.replenish,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );

                  final editButton = OutlinedButton.icon(
                    onPressed: canManageBusinessData
                        ? onEditItem
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.permissionEditInventoryDenied,
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.edit),
                    label: Text(
                      l10n.edit,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );

                  return Column(
                    children: [
                      LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.white10,
                        color: progressColor,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MetaChip(label: _inventoryTypeLabel(l10n, itemType)),
                          if (minStock > 0)
                            _MetaChip(
                              label: l10n.inventoryMinChip(
                                minStock,
                                unit.label,
                              ),
                            ),
                          if ((item['location']?.toString() ?? '').isNotEmpty)
                            _MetaChip(label: item['location'].toString()),
                        ],
                      ),
                      if ((item['usage']?.toString() ?? '').isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['usage'].toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (isNarrow) ...[
                        SizedBox(width: double.infinity, child: addButton),
                        const SizedBox(height: 8),
                        SizedBox(width: double.infinity, child: editButton),
                      ] else
                        Row(
                          children: [
                            Expanded(child: addButton),
                            const SizedBox(width: 8),
                            Expanded(child: editButton),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
