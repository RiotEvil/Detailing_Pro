import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/access_guard.dart';
import '../core/app_data_service.dart';
import '../core/constants.dart';
import '../core/order_reminder_service.dart';
import '../core/subscription_texts.dart';
import '../models/models.dart';

class AddJobScreen extends StatefulWidget {
  final Order? orderToEdit;
  final String? initialClientName;
  final String? initialClientId;
  final String? initialCar;

  const AddJobScreen({
    super.key,
    this.orderToEdit,
    this.initialClientName,
    this.initialClientId,
    this.initialCar,
  });

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _TeamAssignee {
  final String uid;
  final String label;

  const _TeamAssignee({required this.uid, required this.label});
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _carController;
  late final TextEditingController _assignedMasterController;
  late final TextEditingController _laborCostController;
  late final TextEditingController _materialCostController;
  late final TextEditingController _notesController;

  String? _selectedClient;
  String? _selectedClientId;
  String? _serviceToAdd;
  List<String> _selectedServices = <String>[];
  String? _selectedAssigneeUid;
  String? _selectedAssigneeName;
  DateTime _scheduledDate = DateTime.now();
  TimeOfDay _scheduledTime = TimeOfDay.now();

  double _servicePrice = 0;
  int _serviceDuration = 0;
  bool _isLoading = false;

  bool get _isEdit => widget.orderToEdit != null;

  bool get _canManageBusinessData {
    final settingsBox = Hive.box(HiveBoxes.settings);
    final businessMode = BusinessMode.fromStorage(
      settingsBox.get('businessMode')?.toString(),
    );
    final appRole = AppRole.fromStorage(
      settingsBox.get('appRole')?.toString(),
      mode: businessMode,
    );
    return appRole.canManageOrdersAndClients;
  }

  bool get _isTeamMode {
    final settingsBox = Hive.box(HiveBoxes.settings);
    return BusinessMode.fromStorage(
          settingsBox.get('businessMode')?.toString(),
        ) ==
        BusinessMode.team;
  }

  bool get _isMasterRoleInTeam {
    if (!_isTeamMode) return false;
    final settingsBox = Hive.box(HiveBoxes.settings);
    final appRole = AppRole.fromStorage(
      settingsBox.get('appRole')?.toString(),
      mode: BusinessMode.team,
    );
    return appRole == AppRole.master;
  }

  String? get _currentOrgId {
    final settingsBox = Hive.box(HiveBoxes.settings);
    return settingsBox.get('orgId')?.toString();
  }

  String? get _currentUid {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  void initState() {
    super.initState();

    final editingOrder = widget.orderToEdit;
    _carController = TextEditingController(text: editingOrder?.car ?? '');
    _assignedMasterController = TextEditingController(
      text: editingOrder?.assignedToName ?? _currentUserLabel(),
    );
    _laborCostController = TextEditingController(
      text: _formatMoney(editingOrder?.laborCost ?? 0),
    );
    _materialCostController = TextEditingController(
      text: _formatMoney(editingOrder?.materialCost ?? 0),
    );
    _notesController = TextEditingController(text: editingOrder?.notes ?? '');

    _selectedClient = editingOrder?.client;
    _selectedClientId = editingOrder?.clientId;
    _selectedServices = List<String>.from(editingOrder?.services ?? const []);
    if (_selectedServices.isEmpty &&
        (editingOrder?.service ?? '').trim().isNotEmpty) {
      _selectedServices = [editingOrder!.service.trim()];
    }
    _serviceToAdd = _selectedServices.isNotEmpty
        ? _selectedServices.first
        : null;
    _selectedAssigneeUid = editingOrder?.assignedToUid ?? _currentUid;
    _selectedAssigneeName = editingOrder?.assignedToName ?? _currentUserLabel();
    _servicePrice = editingOrder?.price ?? 0;
    _serviceDuration = editingOrder?.duration ?? 0;

    if (editingOrder?.scheduledDate != null) {
      _scheduledDate = editingOrder!.scheduledDate!;
    }

    if ((editingOrder?.scheduledTime ?? '').isNotEmpty) {
      final parts = editingOrder!.scheduledTime!.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          _scheduledTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    }

    if (editingOrder == null) {
      _selectedClient = widget.initialClientName ?? _selectedClient;
      _selectedClientId = widget.initialClientId ?? _selectedClientId;
      if ((widget.initialCar ?? '').trim().isNotEmpty) {
        _carController.text = widget.initialCar!.trim();
      }
    }
  }

  @override
  void dispose() {
    _carController.dispose();
    _assignedMasterController.dispose();
    _laborCostController.dispose();
    _materialCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canManageBusinessData = _canManageBusinessData;
    final settingsBox = Hive.box(HiveBoxes.settings);
    final currency = settingsBox.get('currency', defaultValue: '€').toString();
    final materialCost = _parseMoney(_materialCostController.text);
    final laborCost = _parseMoney(_laborCostController.text);
    final totalCost = materialCost + laborCost;
    final profit = _servicePrice - totalCost;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.editOrderTitle : l10n.newOrderTitle),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box(HiveBoxes.clients).listenable(),
        builder: (context, Box clientsBox, _) {
          final servicesBox = Hive.box(HiveBoxes.services);

          final clients = clientsBox.values
              .map((c) => c['name']?.toString() ?? '')
              .where((name) => name.trim().isNotEmpty)
              .toList();

          final services = servicesBox.values
              .cast<dynamic>()
              .whereType<Map>()
              .toList();

          _syncClientAndServiceDefaults(clients, services);
          _selectedClientId =
              _resolveClientId(clientsBox, _selectedClient) ??
              _selectedClientId;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedClient,
                  decoration: InputDecoration(
                    labelText: l10n.clientFieldLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  items: clients
                      .map(
                        (name) => DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClient = value;
                      _selectedClientId = _resolveClientId(clientsBox, value);
                      _tryAutofillCarFromClient(
                        clientsBox,
                        value,
                        _selectedClientId,
                      );
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.selectClient;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final clientCars = _resolveClientCars(
                      clientsBox,
                      _selectedClient,
                      _selectedClientId,
                    );

                    final currentCar = _carController.text.trim();
                    final carOptions = List<String>.from(clientCars);
                    if (currentCar.isNotEmpty &&
                        !carOptions.contains(currentCar)) {
                      carOptions.insert(0, currentCar);
                    }

                    if (carOptions.isNotEmpty) {
                      return DropdownButtonFormField<String>(
                        initialValue: currentCar.isNotEmpty
                            ? currentCar
                            : carOptions.first,
                        decoration: InputDecoration(
                          labelText: l10n.carLabel,
                          prefixIcon: const Icon(Icons.directions_car_outlined),
                        ),
                        items: carOptions
                            .map(
                              (car) => DropdownMenuItem<String>(
                                value: car,
                                child: Text(car),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _carController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.enterCar;
                          }
                          return null;
                        },
                      );
                    }

                    return TextFormField(
                      controller: _carController,
                      decoration: InputDecoration(
                        labelText: l10n.carLabel,
                        hintText: l10n.carHint,
                        prefixIcon: const Icon(Icons.directions_car_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.enterCar;
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _serviceToAdd,
                        decoration: InputDecoration(
                          labelText: l10n.serviceFieldLabel,
                          prefixIcon: const Icon(Icons.build_circle_outlined),
                        ),
                        items: services
                            .map((service) {
                              final name = service['name']?.toString() ?? '';
                              if (name.isEmpty) return null;
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Text(name),
                              );
                            })
                            .whereType<DropdownMenuItem<String>>()
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _serviceToAdd = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: (_serviceToAdd ?? '').trim().isEmpty
                            ? null
                            : () {
                                setState(() {
                                  final value = _serviceToAdd!.trim();
                                  if (!_selectedServices.contains(value)) {
                                    _selectedServices = [
                                      ..._selectedServices,
                                      value,
                                    ];
                                  }
                                  _syncServiceDetails(services);
                                });
                              },
                        icon: const Icon(Icons.add),
                        label: Text(l10n.add),
                      ),
                    ),
                  ],
                ),
                if (_selectedServices.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Card(
                    margin: EdgeInsets.zero,
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedServices.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          _reorderSelectedServices(oldIndex, newIndex);
                          _syncServiceDetails(services);
                        });
                      },
                      itemBuilder: (context, index) {
                        final name = _selectedServices[index];
                        return Container(
                          key: ValueKey('service_${index}_$name'),
                          constraints: const BoxConstraints(minHeight: 64),
                          margin: EdgeInsets.only(
                            bottom: index < _selectedServices.length - 1
                                ? 4
                                : 0,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 20,
                                  icon: const Icon(Icons.drag_handle),
                                  color: Colors.white38,
                                  onPressed: null,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    name,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 20,
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _selectedServices = _selectedServices
                                          .where((s) => s != name)
                                          .toList();
                                      _syncServiceDetails(services);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                if (_isTeamMode) ...[
                  const SizedBox(height: 16),
                  _buildAssigneeField(),
                ],
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.statsRevenue,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Text(
                          '${_servicePrice.toStringAsFixed(0)} $currency',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _materialCostController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.orderMaterialCostLabel,
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _laborCostController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n.orderLaborCostLabel,
                    prefixIcon: const Icon(Icons.engineering_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${l10n.serviceFieldLabel} (${l10n.durationMinutesShort})',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Text(
                          '$_serviceDuration ${l10n.durationMinutesShort}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.orderTotalCostLabel,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Text(
                          '${totalCost.toStringAsFixed(0)} $currency',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.orderProfitLabel,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Text(
                          '${profit.toStringAsFixed(0)} $currency',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: profit >= 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(_formatDate(_scheduledDate)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickTime,
                        icon: const Icon(Icons.access_time),
                        label: Text(_formatTime(_scheduledTime)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.orderNotesLabel,
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.notes_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: (_isLoading || !canManageBusinessData)
                      ? null
                      : _saveOrder,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isEdit ? l10n.saveChanges : l10n.createOrderButton,
                        ),
                ),
                if (!canManageBusinessData) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.permissionEditOrderDenied,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _syncClientAndServiceDefaults(List<String> clients, List<Map> services) {
    if (_selectedClient != null && !clients.contains(_selectedClient)) {
      _selectedClient = null;
    }
    if (_selectedClient == null && clients.isNotEmpty) {
      _selectedClient = clients.first;
    }

    final knownServiceNames = services
        .map((s) => s['name']?.toString() ?? '')
        .where((name) => name.trim().isNotEmpty)
        .toSet();

    _selectedServices = _selectedServices
        .where((name) => knownServiceNames.contains(name))
        .toList();

    if (_serviceToAdd != null && !knownServiceNames.contains(_serviceToAdd)) {
      _serviceToAdd = null;
    }
    if (_serviceToAdd == null && services.isNotEmpty) {
      _serviceToAdd = services.first['name']?.toString();
    }

    if (_selectedServices.isEmpty &&
        !_isEdit &&
        (_serviceToAdd ?? '').trim().isNotEmpty) {
      _selectedServices = [_serviceToAdd!.trim()];
    }

    _syncServiceDetails(services);
  }

  void _syncServiceDetails(List<Map> services) {
    if (_selectedServices.isEmpty) {
      _servicePrice = 0;
      _serviceDuration = 0;
      return;
    }

    double totalPrice = 0;
    int totalDuration = 0;
    for (final serviceName in _selectedServices) {
      final selected = services.firstWhere(
        (s) => s['name']?.toString() == serviceName,
        orElse: () => <String, dynamic>{},
      );
      totalPrice += (selected['price'] as num?)?.toDouble() ?? 0;
      totalDuration += (selected['duration'] as num?)?.toInt() ?? 0;
    }

    _servicePrice = totalPrice;
    _serviceDuration = totalDuration;
  }

  void _reorderSelectedServices(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = _selectedServices.removeAt(oldIndex);
    _selectedServices.insert(newIndex, item);
  }

  String? _resolveClientId(Box clientsBox, String? clientName) {
    if (clientName == null || clientName.isEmpty) return null;

    for (final key in clientsBox.keys) {
      final raw = clientsBox.get(key);
      if (raw is! Map) continue;

      if (raw['name']?.toString() == clientName) {
        final existingId = raw['id']?.toString();
        if (existingId != null && existingId.isNotEmpty) {
          return existingId;
        }
        return 'client_${key.toString()}';
      }
    }
    return null;
  }

  void _tryAutofillCarFromClient(
    Box clientsBox,
    String? clientName,
    String? clientId,
  ) {
    final cars = _resolveClientCars(clientsBox, clientName, clientId);
    if (cars.isEmpty) return;

    if (_carController.text.trim().isEmpty ||
        !cars.contains(_carController.text.trim())) {
      _carController.text = cars.first;
    }
  }

  List<String> _resolveClientCars(
    Box clientsBox,
    String? clientName,
    String? clientId,
  ) {
    if ((clientName ?? '').isEmpty && (clientId ?? '').isEmpty) {
      return const [];
    }

    for (final key in clientsBox.keys) {
      final raw = clientsBox.get(key);
      if (raw is! Map) continue;

      final rawId = raw['id']?.toString();
      if (clientId != null && clientId.isNotEmpty && rawId == clientId) {
        return (raw['cars'] as List?)
                ?.map((e) => e.toString())
                .where((e) => e.trim().isNotEmpty)
                .toList() ??
            const [];
      }

      if ((clientId == null || clientId.isEmpty) &&
          raw['name']?.toString() == clientName) {
        return (raw['cars'] as List?)
                ?.map((e) => e.toString())
                .where((e) => e.trim().isNotEmpty)
                .toList() ??
            const [];
      }
    }

    return const [];
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _scheduledDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      if (!mounted) return;
      setState(() {
        _scheduledDate = selected;
      });
    }
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _scheduledTime,
    );

    if (selected != null) {
      if (!mounted) return;
      setState(() {
        _scheduledTime = selected;
      });
    }
  }

  String _formatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    return '$dd.$mm.${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  int _activeOrdersThisMonthCount(Box ordersBox) {
    final now = DateTime.now();
    return ordersBox.values.where((raw) {
      if (raw is! Map) return false;

      final timestamp = (raw['timestamp'] as num?)?.toInt();
      if (timestamp == null || timestamp <= 0) {
        return false;
      }

      final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (createdAt.year != now.year || createdAt.month != now.month) {
        return false;
      }

      final status = OrderStatus.fromName(raw['status']?.toString());
      return status != OrderStatus.completed && status != OrderStatus.paid;
    }).length;
  }

  Future<void> _saveOrder() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_canManageBusinessData) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.permissionSaveOrderDenied)));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectService)));
      return;
    }

    if (!_canEditCurrentOrder()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.permissionEditOrderDenied)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final ordersBox = Hive.box(HiveBoxes.orders);
      final clientsBox = Hive.box(HiveBoxes.clients);

      if (!AccessGuard.canCreateOrderThisMonth(
        activeOrdersThisMonthCount: _activeOrdersThisMonthCount(ordersBox),
        isEditing: _isEdit,
      )) {
        await AccessGuard.showUpgradePrompt(
          context,
          title: SubscriptionTexts.freeOrderLimitTitle(context),
          message: SubscriptionTexts.freeOrderLimitMessage(
            context,
            AccessGuard.freeActiveOrdersPerMonthLimit,
          ),
          requiredPlan: AppPlan.pro,
        );
        return;
      }

      final resolvedClientId =
          _resolveClientId(clientsBox, _selectedClient) ??
          _selectedClientId ??
          widget.orderToEdit?.clientId;

      final scheduledDateTime = DateTime(
        _scheduledDate.year,
        _scheduledDate.month,
        _scheduledDate.day,
        _scheduledTime.hour,
        _scheduledTime.minute,
      );

      // Ensure every order has a stable ID for cloud tracking.
      final orderId =
          (widget.orderToEdit?.id != null && widget.orderToEdit!.id!.isNotEmpty)
          ? widget.orderToEdit!.id!
          : DateTime.now().microsecondsSinceEpoch.toString();

      final order = Order(
        id: orderId,
        clientId: resolvedClientId,
        car: _carController.text.trim(),
        client: _selectedClient!.trim(),
        service: _selectedServices.join(', '),
        services: _selectedServices,
        assignedToUid: _resolveAssignedUid(),
        assignedToName: _resolveAssignedName(),
        duration: _serviceDuration,
        price: _servicePrice,
        materialCost: _parseMoney(_materialCostController.text),
        laborCost: _parseMoney(_laborCostController.text),
        status: widget.orderToEdit?.status ?? OrderStatus.scheduled,
        timestamp: widget.orderToEdit?.timestamp ?? DateTime.now(),
        scheduledDate: scheduledDateTime,
        scheduledTime: _formatTime(_scheduledTime),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        photos: widget.orderToEdit?.photos ?? const [],
      );

      if (_isEdit) {
        final targetKey = ordersBox.keys.firstWhere((k) {
          final current = ordersBox.get(k);
          if (current is! Map) return false;
          if (widget.orderToEdit?.id != null &&
              current['id']?.toString() == widget.orderToEdit!.id) {
            return true;
          }
          return current['timestamp'] ==
                  widget.orderToEdit?.timestamp?.millisecondsSinceEpoch &&
              current['car']?.toString() == widget.orderToEdit?.car;
        }, orElse: () => null);

        if (targetKey != null) {
          await ordersBox.put(targetKey, order.toMap());
        } else {
          await ordersBox.add(order.toMap());
        }
      } else {
        await ordersBox.add(order.toMap());
      }

      // Fire-and-forget sync to Firestore
      unawaited(AppDataService.syncOrderToCloud(order.toMap()));

      final orderMap = order.toMap();
      if (_isCompletedStatus(order.status)) {
        unawaited(OrderReminderService.cancelForOrder(order.id));
      } else {
        unawaited(
          OrderReminderService.scheduleForOrder(order: orderMap, l10n: l10n),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? l10n.orderUpdated : l10n.orderCreated),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorMessage(e.toString())),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isCompletedStatus(OrderStatus status) {
    return status == OrderStatus.completed || status == OrderStatus.paid;
  }

  double _parseMoney(String raw) {
    return double.tryParse(raw.trim().replaceAll(',', '.')) ?? 0;
  }

  String _formatMoney(double value) {
    if (value == 0) {
      return '';
    }
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  String _currentUserLabel() {
    final settings = Hive.box(HiveBoxes.settings);
    final local = settings.get('authUserLabel')?.toString().trim();
    if (local != null && local.isNotEmpty) {
      return local;
    }

    if (Firebase.apps.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final cloud = user?.displayName?.trim();
      if (cloud != null && cloud.isNotEmpty) {
        return cloud;
      }
      final email = user?.email?.trim();
      if (email != null && email.isNotEmpty) {
        return email;
      }
    }

    return 'Master';
  }

  bool _canEditCurrentOrder() {
    if (!_isMasterRoleInTeam || !_isEdit) {
      return true;
    }

    final order = widget.orderToEdit;
    if (order == null) {
      return true;
    }

    final assignedUid = order.assignedToUid?.trim();
    final assignedName = order.assignedToName?.trim().toLowerCase();
    final currentUid = _currentUid;
    final currentLabel = _currentUserLabel().trim().toLowerCase();

    final isMineByUid =
        currentUid != null && assignedUid != null && assignedUid == currentUid;
    final isMineByLabel =
        assignedName != null &&
        assignedName.isNotEmpty &&
        assignedName == currentLabel;
    final isUnassigned =
        (assignedUid == null || assignedUid.isEmpty) &&
        (assignedName == null || assignedName.isEmpty);

    return isMineByUid || isMineByLabel || isUnassigned;
  }

  String _resolveAssignedName() {
    if (!_isTeamMode) {
      return _currentUserLabel();
    }

    final selectedName = _selectedAssigneeName?.trim();
    if (selectedName != null && selectedName.isNotEmpty) {
      return selectedName;
    }

    final typedName = _assignedMasterController.text.trim();
    if (typedName.isNotEmpty) {
      return typedName;
    }

    return _currentUserLabel();
  }

  Widget _buildAssigneeField() {
    if (Firebase.apps.isEmpty || (_currentOrgId ?? '').isEmpty) {
      return TextFormField(
        controller: _assignedMasterController,
        decoration: const InputDecoration(
          labelText: 'Master',
          prefixIcon: Icon(Icons.badge_outlined),
        ),
      );
    }

    final query = fs.FirebaseFirestore.instance
        .collection('public_users')
        .where('orgId', isEqualTo: _currentOrgId);

    return StreamBuilder<fs.QuerySnapshot<Map<String, dynamic>>>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator(minHeight: 2);
        }

        final members =
            snapshot.data!.docs
                .map((doc) {
                  final data = doc.data();
                  final role = data['role']?.toString();
                  if (role != AppRole.master.name &&
                      role != AppRole.masterOwner.name &&
                      role != AppRole.director.name) {
                    return null;
                  }

                  final label =
                      data['displayName']?.toString().trim().isNotEmpty == true
                      ? data['displayName'].toString().trim()
                      : (data['email']?.toString().trim().isNotEmpty == true
                            ? data['email'].toString().trim()
                            : doc.id);

                  return _TeamAssignee(uid: doc.id, label: label);
                })
                .whereType<_TeamAssignee>()
                .toList()
              ..sort(
                (a, b) =>
                    a.label.toLowerCase().compareTo(b.label.toLowerCase()),
              );

        if (members.isEmpty) {
          return TextFormField(
            controller: _assignedMasterController,
            decoration: const InputDecoration(
              labelText: 'Master',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
          );
        }

        final selectedUid = members.any((m) => m.uid == _selectedAssigneeUid)
            ? _selectedAssigneeUid
            : null;

        if (selectedUid == null && _selectedAssigneeUid == null) {
          _selectedAssigneeUid = members.first.uid;
          _selectedAssigneeName = members.first.label;
          _assignedMasterController.text = members.first.label;
        }

        return DropdownButtonFormField<String>(
          initialValue: selectedUid,
          decoration: const InputDecoration(
            labelText: 'Master',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          items: members
              .map(
                (m) => DropdownMenuItem<String>(
                  value: m.uid,
                  child: Text(m.label),
                ),
              )
              .toList(),
          onChanged: (uid) {
            if (uid == null) return;
            final selected = members.firstWhere((m) => m.uid == uid);
            setState(() {
              _selectedAssigneeUid = selected.uid;
              _selectedAssigneeName = selected.label;
              _assignedMasterController.text = selected.label;
            });
          },
        );
      },
    );
  }

  String? _resolveAssignedUid() {
    if (!_isTeamMode) {
      return null;
    }
    if ((_selectedAssigneeUid ?? '').isNotEmpty) {
      return _selectedAssigneeUid;
    }
    if (Firebase.apps.isEmpty) {
      return null;
    }
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
