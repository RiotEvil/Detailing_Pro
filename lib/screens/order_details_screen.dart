import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_data_service.dart';
import '../core/constants.dart';
import '../core/invoice_service.dart';
import '../core/order_services.dart';
import '../models/model_utils.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.orderData,
    required this.currency,
  });

  final Map orderData;
  final String currency;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final ImagePicker _picker = ImagePicker();
  late Map<String, dynamic> _orderData;

  String _servicesForDetails() {
    final items = orderServiceList(_orderData);
    if (items.isEmpty) {
      return '-';
    }
    if (items.length == 1) {
      return items.first;
    }
    return items.map((item) => '• $item').join('\n');
  }

  @override
  void initState() {
    super.initState();
    _orderData = Map<String, dynamic>.from(widget.orderData);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = OrderStatus.fromName(_orderData['status']?.toString());
    final revenue = parseDouble(_orderData['price'], field: 'Order.price');
    final materialCost = parseDouble(
      _orderData['materialCost'],
      field: 'Order.materialCost',
    );
    final laborCost = parseDouble(
      _orderData['laborCost'],
      field: 'Order.laborCost',
    );
    final totalCost = materialCost + laborCost;
    final profit = revenue - totalCost;
    final notes = _orderData['notes']?.toString().trim() ?? '';
    final beforePhotos = _readPhotoList(_orderData['beforePhotos']);
    final afterPhotos = _readPhotoList(_orderData['afterPhotos']);
    final legacyPhotos = _readPhotoList(_orderData['photos']);
    final fallbackAfterPhotos = afterPhotos.isEmpty
        ? legacyPhotos
        : afterPhotos;
    final canManagePhotos = _canManagePhotos();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _orderData['car']?.toString().trim().isNotEmpty == true
              ? _orderData['car'].toString()
              : l10n.carLabel,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: l10n.invoiceGenerateButton,
            onPressed: () => InvoiceService.generateAndPrint(
              context: context,
              orderData: _orderData,
              currency: widget.currency,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.person_outline,
                    label: l10n.clientFieldLabel,
                    value: _orderData['client']?.toString() ?? '-',
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.build_circle_outlined,
                    label: l10n.serviceFieldLabel,
                    value: _servicesForDetails(),
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.payments_outlined,
                    label: l10n.statsRevenue,
                    value: '${revenue.toStringAsFixed(0)} ${widget.currency}',
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.inventory_2_outlined,
                    label: l10n.orderMaterialCostLabel,
                    value:
                        '${materialCost.toStringAsFixed(0)} ${widget.currency}',
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.engineering_outlined,
                    label: l10n.orderLaborCostLabel,
                    value: '${laborCost.toStringAsFixed(0)} ${widget.currency}',
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.receipt_long_outlined,
                    label: l10n.orderTotalCostLabel,
                    value: '${totalCost.toStringAsFixed(0)} ${widget.currency}',
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.trending_up_outlined,
                    label: l10n.orderProfitLabel,
                    value: '${profit.toStringAsFixed(0)} ${widget.currency}',
                    valueColor: profit >= 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.flag_outlined,
                    label: l10n.statusChangedTitle,
                    value: status.localizedLabel(l10n),
                    valueColor: status.color,
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: l10n.calendarTitle,
                    value: _buildScheduleValue(_orderData),
                  ),
                ],
              ),
            ),
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _DetailRow(
                  icon: Icons.notes_outlined,
                  label: l10n.orderNotesLabel,
                  value: notes,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          _PhotoSectionCard(
            title: l10n.orderBeforePhotosTitle,
            photos: beforePhotos,
            emptyText: l10n.photosNotAdded,
            canManagePhotos: canManagePhotos,
            onAddFromGallery: () => _pickPhoto(ImageSource.gallery, true),
            onTakePhoto: () => _pickPhoto(ImageSource.camera, true),
            onOpen: _openPhotoViewer,
            onDelete: (path) => _deletePhoto(path, true),
          ),
          const SizedBox(height: 12),
          _PhotoSectionCard(
            title: l10n.orderAfterPhotosTitle,
            photos: fallbackAfterPhotos,
            emptyText: l10n.photosNotAdded,
            canManagePhotos: canManagePhotos,
            onAddFromGallery: () => _pickPhoto(ImageSource.gallery, false),
            onTakePhoto: () => _pickPhoto(ImageSource.camera, false),
            onOpen: _openPhotoViewer,
            onDelete: (path) => _deletePhoto(path, false),
          ),
          if (legacyPhotos.isNotEmpty && afterPhotos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.photosTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: legacyPhotos.length,
                        separatorBuilder: (_, index) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final photoPath = legacyPhotos[index];
                          return _OrderPhotoThumb(
                            path: photoPath,
                            canDelete: false,
                            onOpen: () => _openPhotoViewer(photoPath),
                            onDelete: null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _readPhotoList(dynamic raw) {
    return (raw as List?)
            ?.map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList() ??
        const <String>[];
  }

  bool _canManagePhotos() {
    final settings = Hive.box(HiveBoxes.settings);
    final businessMode = BusinessMode.fromStorage(
      settings.get('businessMode')?.toString(),
    );
    final appRole = AppRole.fromStorage(
      settings.get('appRole')?.toString(),
      mode: businessMode,
    );
    return appRole.canManageOrdersAndClients;
  }

  Future<void> _pickPhoto(ImageSource source, bool isBefore) async {
    if (!_canManagePhotos()) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.photosDeleteDenied)));
      return;
    }

    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 88);
      if (picked == null) {
        return;
      }

      final key = isBefore ? 'beforePhotos' : 'afterPhotos';
      final updated = [..._readPhotoList(_orderData[key]), picked.path];
      await _persistPhotos(
        beforePhotos: isBefore
            ? updated
            : _readPhotoList(_orderData['beforePhotos']),
        afterPhotos: isBefore
            ? _readPhotoList(_orderData['afterPhotos'])
            : updated,
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.errorMessage(e.toString()))));
    }
  }

  Future<void> _deletePhoto(String path, bool isBefore) async {
    final beforePhotos = [..._readPhotoList(_orderData['beforePhotos'])];
    final afterPhotos = [..._readPhotoList(_orderData['afterPhotos'])];
    if (isBefore) {
      beforePhotos.remove(path);
    } else {
      afterPhotos.remove(path);
    }
    await _persistPhotos(beforePhotos: beforePhotos, afterPhotos: afterPhotos);
  }

  Future<void> _persistPhotos({
    required List<String> beforePhotos,
    required List<String> afterPhotos,
  }) async {
    final ordersBox = Hive.box(HiveBoxes.orders);
    final orderId = _orderData['id']?.toString();

    dynamic targetKey;
    for (final key in ordersBox.keys) {
      final raw = ordersBox.get(key);
      if (raw is! Map) {
        continue;
      }
      if (orderId != null &&
          orderId.isNotEmpty &&
          raw['id']?.toString() == orderId) {
        targetKey = key;
        break;
      }
    }

    if (targetKey == null) {
      return;
    }

    final mergedPhotos = <String>{...beforePhotos, ...afterPhotos}.toList();
    final updated = Map<String, dynamic>.from(_orderData)
      ..['beforePhotos'] = beforePhotos
      ..['afterPhotos'] = afterPhotos
      ..['photos'] = mergedPhotos;

    await ordersBox.put(targetKey, updated);
    unawaited(AppDataService.syncOrderToCloud(updated));

    if (!mounted) {
      return;
    }

    setState(() {
      _orderData = updated;
    });
  }

  void _openPhotoViewer(String photoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _OrderPhotoViewer(photoPath: photoPath),
      ),
    );
  }

  String _buildScheduleValue(Map order) {
    final date = order['scheduledDate'];
    final time = order['scheduledTime']?.toString() ?? '';

    if (date is num) {
      final d = DateTime.fromMillisecondsSinceEpoch(date.toInt());
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      final dateLabel = '$dd.$mm.${d.year}';
      return time.isNotEmpty ? '$dateLabel $time' : dateLabel;
    }

    return time.isNotEmpty ? time : '-';
  }

}

class _PhotoSectionCard extends StatelessWidget {
  const _PhotoSectionCard({
    required this.title,
    required this.photos,
    required this.emptyText,
    required this.canManagePhotos,
    required this.onAddFromGallery,
    required this.onTakePhoto,
    required this.onOpen,
    required this.onDelete,
  });

  final String title;
  final List<String> photos;
  final String emptyText;
  final bool canManagePhotos;
  final VoidCallback onAddFromGallery;
  final VoidCallback onTakePhoto;
  final void Function(String path) onOpen;
  final void Function(String path) onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library_outlined),
                  tooltip: l10n.photosAddFromGallery,
                  onPressed: canManagePhotos ? onAddFromGallery : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add_a_photo_outlined),
                  tooltip: l10n.photosTakePhoto,
                  onPressed: canManagePhotos ? onTakePhoto : null,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (photos.isEmpty)
              Text(emptyText, style: const TextStyle(color: Colors.grey))
            else
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final photoPath = photos[index];
                    return _OrderPhotoThumb(
                      path: photoPath,
                      canDelete: canManagePhotos,
                      onOpen: () => onOpen(photoPath),
                      onDelete: () => onDelete(photoPath),
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

class _OrderPhotoThumb extends StatelessWidget {
  const _OrderPhotoThumb({
    required this.path,
    required this.canDelete,
    required this.onOpen,
    required this.onDelete,
  });

  final String path;
  final bool canDelete;
  final VoidCallback onOpen;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final image = kIsWeb
        ? Image.network(path, fit: BoxFit.cover)
        : Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox(
              width: 160,
              child: ColoredBox(
                color: Color(0xFF2A2A2A),
                child: Icon(Icons.broken_image_outlined, color: Colors.white54),
              ),
            ),
          );

    return GestureDetector(
      onTap: onOpen,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            SizedBox(width: 160, child: image),
            if (canDelete && onDelete != null)
              Positioned(
                top: 6,
                right: 6,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    onPressed: onDelete,
                    iconSize: 18,
                    constraints: const BoxConstraints.tightFor(
                      width: 34,
                      height: 34,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ),
      ],
    );
  }
}

class _OrderPhotoViewer extends StatelessWidget {
  const _OrderPhotoViewer({required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    final image = kIsWeb
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
