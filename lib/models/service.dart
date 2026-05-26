import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/model_utils.dart';

@immutable
class Service {
  final String? id;
  final String name;
  final double price;
  final int duration;
  final List<String> chemistry;
  final int chemAmount;
  final String? description;
  final String? category;

  const Service({
    this.id,
    required this.name,
    required this.price,
    required this.duration,
    this.chemistry = const [],
    this.chemAmount = 0,
    this.description,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
      'chemistry': chemistry,
      'chemAmount': chemAmount,
      'description': description,
      'category': category,
    };
  }

  factory Service.fromMap(Map<dynamic, dynamic> map) {
    final name = map['name']?.toString() ?? '';
    if (name.isEmpty) debugPrint('[Service] missing name field, id=${map['id']}');
    return Service(
      id: map['id']?.toString(),
      name: name,
      price: parseDouble(map['price'], field: 'Service.price'),
      duration: parseInt(map['duration'], field: 'Service.duration'),
      chemistry: parseStringList(map['chemistry'], field: 'Service.chemistry'),
      chemAmount: parseInt(map['chemAmount'], field: 'Service.chemAmount'),
      description: map['description']?.toString(),
      category: map['category']?.toString(),
    );
  }

  Service copyWith({
    String? id,
    String? name,
    double? price,
    int? duration,
    List<String>? chemistry,
    int? chemAmount,
    ValueGetter<String?>? description,
    ValueGetter<String?>? category,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      chemistry: chemistry ?? this.chemistry,
      chemAmount: chemAmount ?? this.chemAmount,
      description: description != null ? description() : this.description,
      category: category != null ? category() : this.category,
    );
  }

  /// Форматирование времени (например, 130 мин -> 2ч 10мин)
  String get formattedDuration {
    if (duration <= 0) return '0 мин';
    if (duration >= 60) {
      final hours = duration ~/ 60;
      final mins = duration % 60;
      return mins > 0 ? '$hoursч $minsмин' : '$hoursч';
    }
    return '$duration мин';
  }

  /// Вывод списка химии через запятую
  String get formattedChemistry =>
      chemistry.isEmpty ? 'Not specified' : chemistry.join(', ');
}
