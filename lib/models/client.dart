import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/model_utils.dart';

@immutable
class Client {
  final String? id;
  final String name;
  final String? phone;
  final String? email;
  final String? notes;
  final List<String> tags;
  final Map<String, String> carPhotos;
  final String? carPhotoPath;
  final List<String> cars;
  final DateTime? createdAt;

  const Client({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.notes,
    this.tags = const [],
    this.carPhotos = const {},
    this.carPhotoPath,
    this.cars = const [],
    this.createdAt,
  });

  /// Геттер для отображения списка машин через запятую
  String get carsFormatted => cars.join(', ');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'notes': notes,
      'tags': tags,
      'carPhotos': carPhotos,
      'carPhotoPath': carPhotoPath,
      'cars': cars,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory Client.fromMap(Map<dynamic, dynamic> map) {
    final cars = parseStringList(map['cars'], field: 'Client.cars');
    final tags = parseStringList(map['tags'], field: 'Client.tags')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final rawCarPhotos = map['carPhotos'];
    final parsedCarPhotos = <String, String>{};
    if (rawCarPhotos is Map) {
      for (final entry in rawCarPhotos.entries) {
        final key = entry.key.toString();
        final value = entry.value?.toString() ?? '';
        if (key.isNotEmpty && value.isNotEmpty) {
          parsedCarPhotos[key] = value;
        }
      }
    }

    final legacyPath = map['carPhotoPath']?.toString();
    if (parsedCarPhotos.isEmpty &&
        legacyPath != null &&
        legacyPath.isNotEmpty &&
        cars.isNotEmpty) {
      parsedCarPhotos[cars.first] = legacyPath;
    }

    final name = map['name']?.toString() ?? '';
    if (name.isEmpty) debugPrint('[Client] missing name field, id=${map['id']}');

    return Client(
      id: map['id']?.toString(),
      name: name,
      phone: map['phone']?.toString(),
      email: map['email']?.toString(),
      notes: map['notes']?.toString(),
      tags: tags,
      carPhotos: parsedCarPhotos,
      carPhotoPath: map['carPhotoPath']?.toString(),
      cars: cars,
      createdAt: map['createdAt'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  String? photoForCar(String car) {
    final photo = carPhotos[car];
    if (photo != null && photo.isNotEmpty) return photo;
    if (carPhotoPath != null &&
        carPhotoPath!.isNotEmpty &&
        cars.isNotEmpty &&
        cars.first == car) {
      return carPhotoPath;
    }
    return null;
  }

  /// Улучшенный copyWith: позволяет занулять phone и createdAt
  Client copyWith({
    String? id,
    String? name,
    ValueGetter<String?>? phone,
    ValueGetter<String?>? email,
    ValueGetter<String?>? notes,
    List<String>? tags,
    Map<String, String>? carPhotos,
    ValueGetter<String?>? carPhotoPath,
    List<String>? cars,
    ValueGetter<DateTime?>? createdAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone != null ? phone() : this.phone,
      email: email != null ? email() : this.email,
      notes: notes != null ? notes() : this.notes,
      tags: tags ?? this.tags,
      carPhotos: carPhotos ?? this.carPhotos,
      carPhotoPath: carPhotoPath != null ? carPhotoPath() : this.carPhotoPath,
      cars: cars ?? this.cars,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }
}
