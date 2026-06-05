import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../core/access_guard.dart';
import '../core/analytics_service.dart';
import '../core/app_data_service.dart';
import '../core/cloud_file_storage.dart';
import '../core/constants.dart';
import '../core/subscription_texts.dart';
import '../models/client.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/free_limit_banner.dart';

class AddClientScreen extends StatefulWidget {
  final Client? clientToEdit;
  final dynamic clientKey;

  const AddClientScreen({super.key, this.clientToEdit, this.clientKey});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Контроллеры
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _notesController;
  late TextEditingController _tagsController;
  late TextEditingController _carController;

  // Состояние
  final List<String> _cars = [];
  final Map<String, String> _carPhotos = {};
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры данными, если они есть
    _nameController = TextEditingController(
      text: widget.clientToEdit?.name ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.clientToEdit?.phone ?? '',
    );
    _emailController = TextEditingController(
      text: widget.clientToEdit?.email ?? '',
    );
    _notesController = TextEditingController(
      text: widget.clientToEdit?.notes ?? '',
    );
    _tagsController = TextEditingController(
      text: widget.clientToEdit?.tags.join(', ') ?? '',
    );
    _carController = TextEditingController();

    if (widget.clientToEdit != null) {
      _cars.addAll(widget.clientToEdit!.cars);
      _carPhotos.addAll(widget.clientToEdit!.carPhotos);
      // Миграция legacy single-photo формата
      if (_carPhotos.isEmpty &&
          widget.clientToEdit!.carPhotoPath != null &&
          widget.clientToEdit!.carPhotoPath!.isNotEmpty &&
          _cars.isNotEmpty) {
        _carPhotos[_cars.first] = widget.clientToEdit!.carPhotoPath!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _carController.dispose();
    super.dispose();
  }

  List<String> _parseTags(String raw) {
    final seen = <String>{};
    final result = <String>[];
    for (final part in raw.split(',')) {
      final tag = part.trim();
      if (tag.isEmpty) continue;
      final key = tag.toLowerCase();
      if (seen.add(key)) {
        result.add(tag);
      }
    }
    return result;
  }

  void _addCar() {
    if (!_canManageBusinessData) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.permissionEditClientDenied,
          ),
        ),
      );
      return;
    }

    final car = _carController.text.trim().toUpperCase();
    if (car.isNotEmpty && !_cars.contains(car)) {
      setState(() {
        _cars.add(car);
        _carController.clear();
      });
    }
  }

  Future<void> _pickCarPhoto(String car, ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source, imageQuality: 85);
      if (image == null) return;

      final clientId =
          widget.clientToEdit?.id ??
          DateTime.now().microsecondsSinceEpoch.toString();
      final photoUrl = await CloudFileStorage.uploadClientCarPhoto(
        clientId: clientId,
        car: car,
        file: image,
      );

      setState(() => _carPhotos[car] = photoUrl);
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorMessage(e.toString()))));
    }
  }

  Future<void> _removeCar(String car, AppLocalizations l10n) async {
    final hasPhoto = (_carPhotos[car] ?? '').isNotEmpty;
    if (hasPhoto) {
      final confirmed = await ConfirmDialog.show(
        context: context,
        title: l10n.deleteItemTitle,
        message: l10n.deleteItemMessage(car),
        confirmText: l10n.delete,
        cancelText: l10n.cancel,
        icon: Icons.delete_forever,
      );
      if (confirmed != true) return;
    }

    if (!mounted) return;
    setState(() {
      _carPhotos.remove(car);
      _cars.remove(car);
    });
  }

  Widget _buildCarPhotoPreview(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) {
      return Container(
        height: 56,
        width: 72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: const Icon(Icons.directions_car, size: 28, color: Colors.grey),
      );
    }

    final isRemote =
        photoPath.startsWith('http://') || photoPath.startsWith('https://');
    final imageWidget = (kIsWeb || isRemote)
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
      child: SizedBox(height: 56, width: 72, child: imageWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем l10n один раз
    final l10n = AppLocalizations.of(context)!;
    final canManageBusinessData = _canManageBusinessData;

    final clientsBox = Hive.box(HiveBoxes.clients);
    final clientCount = AccessGuard.countClients(clientsBox);
    final clientSlotsLeft = AccessGuard.freeClientsLimit - clientCount;
    final showClientWarning = AccessGuard.enforcesFreePlanLimits() &&
        widget.clientToEdit == null &&
        clientSlotsLeft == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.clientToEdit != null ? l10n.editClient : l10n.newClient,
        ),
      ),
      bottomNavigationBar: showClientWarning
          ? FreeLimitBanner(
              message: SubscriptionTexts.clientSlotWarning(context, 1),
              buttonLabel: SubscriptionTexts.upgradeLabel(context),
              onUpgrade: () => AccessGuard.showSoftPaywall(context),
            )
          : null,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(l10n.clientNameLabel.toUpperCase()),
                const SizedBox(height: 8),

                Card(
                  elevation: 0,
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // Поле Имя
                        _buildCustomTextField(
                          controller: _nameController,
                          label: l10n.clientFieldLabel,
                          icon: Icons.person_rounded,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? l10n.enterName : null,
                        ),
                        const SizedBox(height: 16),

                        // Поле Телефон
                        _buildCustomTextField(
                          controller: _phoneController,
                          label: l10n.phoneLabel,
                          hint: l10n.phoneHint,
                          icon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return null;
                            final cleaned = v.replaceAll(
                              RegExp(r'[\s\-\(\)]'),
                              '',
                            );
                            if (!RegExp(r'^\+?\d{7,15}$').hasMatch(cleaned)) {
                              return l10n.enterValidPhone;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Поле Email
                        _buildCustomTextField(
                          controller: _emailController,
                          label: l10n.emailLabel,
                          hint: 'client@example.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return null;
                            if (!RegExp(
                              r'^[\w.+-]+@[\w-]+\.[\w.]+$',
                            ).hasMatch(v.trim())) {
                              return l10n.authInvalidEmailFormat;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _buildCustomTextField(
                          controller: _notesController,
                          label: l10n.orderNotesLabel,
                          icon: Icons.sticky_note_2_outlined,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        _buildCustomTextField(
                          controller: _tagsController,
                          label: l10n.crmTagsLabel,
                          hint: l10n.crmTagsHint,
                          icon: Icons.local_offer_outlined,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _buildSectionTitle(l10n.carsLabel.toUpperCase()),
                const SizedBox(height: 8),

                // Добавление авто
                Row(
                  children: [
                    Expanded(
                      child: _buildCustomTextField(
                        controller: _carController,
                        label: l10n.carLabel,
                        icon: Icons.directions_car_filled_rounded,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: canManageBusinessData ? _addCar : null,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Список чипов (машины)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _cars
                      .map(
                        (car) => _buildCarChip(
                          car,
                          l10n: l10n,
                          canManageBusinessData: canManageBusinessData,
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 50),

                // Большая кнопка сохранения
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_isLoading || !canManageBusinessData)
                        ? null
                        : _saveClient,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.clientToEdit != null
                                ? l10n.saveChanges
                                : l10n.saveClient,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
                if (!canManageBusinessData) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.permissionEditClientDenied,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- ВСПОМОГАТЕЛЬНЫЕ ВИДЖЕТЫ (ТО ЧТО СОЗДАЕТ ОБЪЕМ КОДА) ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildCarChip(
    String car, {
    required AppLocalizations l10n,
    required bool canManageBusinessData,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          _buildCarPhotoPreview(_carPhotos[car]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              car,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            tooltip: l10n.photosAddFromGallery,
            onPressed: canManageBusinessData
                ? () => _pickCarPhoto(car, ImageSource.gallery)
                : null,
            icon: const Icon(Icons.photo_library_outlined, size: 20),
          ),
          IconButton(
            tooltip: l10n.photosTakePhoto,
            onPressed: canManageBusinessData
                ? () => _pickCarPhoto(car, ImageSource.camera)
                : null,
            icon: const Icon(Icons.add_a_photo_outlined, size: 20),
          ),
          IconButton(
            tooltip: l10n.delete,
            onPressed: canManageBusinessData
                ? () => _removeCar(car, l10n)
                : null,
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _saveClient() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_canManageBusinessData) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.permissionSaveClientDenied)));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cBox = Hive.box(HiveBoxes.clients);

      if (!AccessGuard.canCreateClient(
        existingClientsCount: AccessGuard.countClients(cBox),
        isEditing: widget.clientToEdit != null,
      )) {
        await AccessGuard.showSoftPaywall(context);
        return;
      }

      final client = Client(
        id:
            widget.clientToEdit?.id ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        cars: _cars,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim().toLowerCase(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        tags: _parseTags(_tagsController.text),
        carPhotos: Map<String, String>.from(_carPhotos)
          ..removeWhere((key, value) => !_cars.contains(key) || value.isEmpty),
        carPhotoPath: _cars.isNotEmpty ? _carPhotos[_cars.first] : null,
        createdAt: widget.clientToEdit?.createdAt ?? DateTime.now(),
      );

      if (widget.clientToEdit != null) {
        dynamic keyToUpdate = widget.clientKey;

        // Fallback для старых переходов, где ключ не передан.
        if (keyToUpdate == null) {
          final entries = cBox.toMap();
          entries.forEach((key, value) {
            if (value['name'] == widget.clientToEdit!.name) {
              keyToUpdate = key;
            }
          });
        }

        if (keyToUpdate != null) {
          await cBox.put(keyToUpdate, client.toMap());
        }
      } else {
        await cBox.add(client.toMap());
      }

      // Fire-and-forget sync to Firestore
      unawaited(AppDataService.syncClientToCloud(client.toMap()));
      unawaited(AnalyticsService.logClientCreated());

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
