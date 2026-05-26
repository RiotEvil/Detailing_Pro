import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants.dart';
import 'package:flutter_application_1/models/model_utils.dart';

@immutable
class Order {
  final String? id;
  final String? clientId;
  final String car;
  final String client;
  final String service;
  final List<String> services;
  final String? assignedToUid;
  final String? assignedToName;
  final int duration;
  final double price;
  final double materialCost;
  final double laborCost;
  final OrderStatus status;
  final DateTime? timestamp;
  final DateTime? scheduledDate;
  final String? scheduledTime;
  final String? notes;
  final List<String> photos;
  final List<String> beforePhotos;
  final List<String> afterPhotos;

  const Order({
    this.id,
    this.clientId,
    required this.car,
    required this.client,
    required this.service,
    this.services = const [],
    this.assignedToUid,
    this.assignedToName,
    required this.duration,
    required this.price,
    this.materialCost = 0,
    this.laborCost = 0,
    this.status = OrderStatus.scheduled,
    this.timestamp,
    this.scheduledDate,
    this.scheduledTime,
    this.notes,
    this.photos = const [],
    this.beforePhotos = const [],
    this.afterPhotos = const [],
  });

  Map<String, dynamic> toMap() {
    final mergedPhotos = <String>{
      ...photos,
      ...beforePhotos,
      ...afterPhotos,
    }.toList();

    final normalizedServices = services
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (normalizedServices.isEmpty && service.trim().isNotEmpty) {
      normalizedServices.add(service.trim());
    }

    final displayService = service.trim().isNotEmpty
        ? service.trim()
        : normalizedServices.join(', ');

    return {
      'id': id,
      'clientId': clientId,
      'car': car,
      'client': client,
      'service': displayService,
      'services': normalizedServices,
      'assignedToUid': assignedToUid,
      'assignedToName': assignedToName,
      'duration': duration,
      'price': price,
      'materialCost': materialCost,
      'laborCost': laborCost,
      'status': status.name,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'scheduledDate': scheduledDate?.millisecondsSinceEpoch,
      'scheduledTime': scheduledTime,
      'notes': notes,
      'photos': mergedPhotos,
      'beforePhotos': beforePhotos,
      'afterPhotos': afterPhotos,
    };
  }

  factory Order.fromMap(Map<dynamic, dynamic> map) {
    final legacyPhotos = parseStringList(map['photos'], field: 'Order.photos');
    final parsedBeforePhotos = parseStringList(map['beforePhotos'], field: 'Order.beforePhotos');
    final parsedAfterPhotos = map['afterPhotos'] != null
        ? parseStringList(map['afterPhotos'], field: 'Order.afterPhotos')
        : legacyPhotos;
    final parsedServices = parseStringList(map['services'], field: 'Order.services')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final displayService = map['service']?.toString().trim() ?? '';
    final effectiveServices = parsedServices.isNotEmpty
        ? parsedServices
        : (displayService.isNotEmpty ? <String>[displayService] : <String>[]);

    final car = map['car']?.toString() ?? '';
    final client = map['client']?.toString() ?? '';
    if (car.isEmpty) debugPrint('[Order] missing car field, id=${map['id']}');
    if (client.isEmpty) debugPrint('[Order] missing client field, id=${map['id']}');

    return Order(
      id: map['id']?.toString(),
      clientId: map['clientId']?.toString(),
      car: car,
      client: client,
      service: displayService,
      services: effectiveServices,
      assignedToUid: map['assignedToUid']?.toString(),
      assignedToName: map['assignedToName']?.toString(),
      duration: parseInt(map['duration'], field: 'Order.duration'),
      price: parseDouble(map['price'], field: 'Order.price'),
      materialCost: parseDouble(map['materialCost'], field: 'Order.materialCost'),
      laborCost: parseDouble(map['laborCost'], field: 'Order.laborCost'),
      status: OrderStatus.fromName(map['status']?.toString()),
      timestamp: map['timestamp'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
          : null,
      scheduledDate: map['scheduledDate'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['scheduledDate'] as int)
          : null,
      scheduledTime: map['scheduledTime']?.toString(),
      notes: map['notes']?.toString(),
      photos: legacyPhotos,
      beforePhotos: parsedBeforePhotos,
      afterPhotos: parsedAfterPhotos,
    );
  }

  Order copyWith({
    String? id,
    String? Function()? clientId,
    String? car,
    String? client,
    String? service,
    List<String>? services,
    String? Function()? assignedToUid,
    String? Function()? assignedToName,
    int? duration,
    double? price,
    double? materialCost,
    double? laborCost,
    OrderStatus? status,
    DateTime? timestamp,
    DateTime? Function()? scheduledDate,
    String? Function()? scheduledTime,
    String? Function()? notes,
    List<String>? photos,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
  }) {
    return Order(
      id: id ?? this.id,
      clientId: clientId != null ? clientId() : this.clientId,
      car: car ?? this.car,
      client: client ?? this.client,
      service: service ?? this.service,
      services: services ?? this.services,
      assignedToUid: assignedToUid != null
          ? assignedToUid()
          : this.assignedToUid,
      assignedToName: assignedToName != null
          ? assignedToName()
          : this.assignedToName,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      materialCost: materialCost ?? this.materialCost,
      laborCost: laborCost ?? this.laborCost,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      scheduledDate: scheduledDate != null
          ? scheduledDate()
          : this.scheduledDate,
      scheduledTime: scheduledTime != null
          ? scheduledTime()
          : this.scheduledTime,
      notes: notes != null ? notes() : this.notes,
      photos: photos ?? this.photos,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
    );
  }
}
