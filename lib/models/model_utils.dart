import 'package:flutter/foundation.dart';

double parseDouble(
  Object? v, {
  required String field,
  double defaultValue = 0.0,
}) {
  if (v == null) return defaultValue;
  if (v is num) return v.toDouble();
  if (v is String) {
    final p = double.tryParse(v);
    if (p != null) return p;
  }
  debugPrint('[Model] $field: unexpected ${v.runtimeType}($v), using $defaultValue');
  return defaultValue;
}

int parseInt(
  Object? v, {
  required String field,
  int defaultValue = 0,
}) {
  if (v == null) return defaultValue;
  if (v is num) return v.toInt();
  if (v is String) {
    final p = int.tryParse(v);
    if (p != null) return p;
  }
  debugPrint('[Model] $field: unexpected ${v.runtimeType}($v), using $defaultValue');
  return defaultValue;
}

List<String> parseStringList(Object? v, {required String field}) {
  if (v == null) return const [];
  if (v is List) return v.map((e) => e.toString()).toList();
  debugPrint('[Model] $field: expected List, got ${v.runtimeType}, using []');
  return const [];
}
