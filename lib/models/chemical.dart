import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/model_utils.dart';

@immutable
class Chemical {
  final String? id;
  final String name;
  final String brand;
  final String category;
  final String? pH;
  final String? dilution;
  final String? usage;
  final int amount;
  final int minAmount; // Убрал nullability, так как есть дефолтное значение

  const Chemical({
    this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.pH,
    this.dilution,
    this.usage,
    this.amount = 0,
    this.minAmount = 200,
  });

  /// Проверка на критический остаток
  bool get isLow => amount <= minAmount;

  /// Процент заполненности (полезно для ProgressBar в UI)
  double get percentage => amount > 1000 ? 1.0 : amount / 1000;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'pH': pH,
      'dilution': dilution,
      'usage': usage,
      'amount': amount,
      'minAmount': minAmount,
    };
  }

  factory Chemical.fromMap(Map<dynamic, dynamic> map) {
    final name = map['name']?.toString() ?? '';
    if (name.isEmpty) debugPrint('[Chemical] missing name field, id=${map['id']}');
    return Chemical(
      id: map['id']?.toString(),
      name: name,
      brand: map['brand']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      pH: map['pH']?.toString(),
      dilution: map['dilution']?.toString(),
      usage: map['usage']?.toString(),
      amount: parseInt(map['amount'], field: 'Chemical.amount'),
      minAmount: parseInt(map['minAmount'], field: 'Chemical.minAmount', defaultValue: 200),
    );
  }

  /// Улучшенный copyWith: позволяет явно занулять поля при необходимости
  Chemical copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    ValueGetter<String?>? pH,
    ValueGetter<String?>? dilution,
    ValueGetter<String?>? usage,
    int? amount,
    int? minAmount,
  }) {
    return Chemical(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      pH: pH != null ? pH() : this.pH,
      dilution: dilution != null ? dilution() : this.dilution,
      usage: usage != null ? usage() : this.usage,
      amount: amount ?? this.amount,
      minAmount: minAmount ?? this.minAmount,
    );
  }
}
