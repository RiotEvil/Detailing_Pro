import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateResult {
  final bool required;
  final String? storeUrl;

  const ForceUpdateResult({required this.required, this.storeUrl});
}

class ForceUpdateService {
  ForceUpdateService._();

  static ForceUpdateResult? _cached;
  static DateTime? _cachedAt;
  static const _cacheTtl = Duration(hours: 4);

  /// Checks Firestore `app_config/versions` for the minimum required app build.
  /// Supports either semantic-only values like `1.0.1`, combined values like
  /// `1.0.1+7`, or explicit build fields like `minAndroidBuild` / `minIosBuild`.
  /// Returns [ForceUpdateResult.required] = true if the current build is outdated.
  /// Always returns false on web (web always serves the latest build).
  /// Result is cached for 4 hours to avoid redundant Firestore reads on every resume.
  static Future<ForceUpdateResult> check() async {
    final now = DateTime.now();
    if (_cached != null &&
        _cachedAt != null &&
        now.difference(_cachedAt!) < _cacheTtl) {
      return _cached!;
    }
    if (kIsWeb) return const ForceUpdateResult(required: false);
    if (Firebase.apps.isEmpty) return const ForceUpdateResult(required: false);

    try {
      final snap = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('versions')
          .get();

      if (!snap.exists) return const ForceUpdateResult(required: false);

      final data = snap.data()!;

      String? minVersion;
      int? minBuildNumber;
      String? storeUrl;

      if (defaultTargetPlatform == TargetPlatform.android) {
        minVersion = data['minAndroid']?.toString();
        minBuildNumber = _parseBuildNumber(data['minAndroidBuild']);
        storeUrl = data['androidUrl']?.toString();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        minVersion = data['minIos']?.toString();
        minBuildNumber = _parseBuildNumber(data['minIosBuild']);
        storeUrl = data['iosUrl']?.toString();
      } else {
        // Windows / desktop — no store URL, still honour minVersion if present
        minVersion = data['minVersion']?.toString();
        minBuildNumber = _parseBuildNumber(data['minBuildNumber']);
        storeUrl = data['downloadUrl']?.toString();
      }

      if ((minVersion == null || minVersion.isEmpty) &&
          minBuildNumber == null) {
        return const ForceUpdateResult(required: false);
      }

      final info = await PackageInfo.fromPlatform();
      final minimum = _MinimumBuild.parse(
        version: minVersion,
        explicitBuildNumber: minBuildNumber,
      );

      if (_isOlderThan(
        version: info.version,
        buildNumber: info.buildNumber,
        minimum: minimum,
      )) {
        _cached = ForceUpdateResult(required: true, storeUrl: storeUrl);
        _cachedAt = now;
        return _cached!;
      }
    } catch (e) {
      debugPrint('[ForceUpdate] check error: $e');
    }

    _cached = const ForceUpdateResult(required: false);
    _cachedAt = now;
    return _cached!;
  }

  /// Returns true if the current app build is strictly older than [minimum].
  static bool _isOlderThan({
    required String version,
    required String buildNumber,
    required _MinimumBuild minimum,
  }) {
    final currentVersion = _parseVersion(version);
    final requiredVersion = _parseVersion(minimum.version);

    for (int i = 0; i < 3; i++) {
      if (currentVersion[i] < requiredVersion[i]) return true;
      if (currentVersion[i] > requiredVersion[i]) return false;
    }

    if (minimum.buildNumber == null) {
      return false;
    }

    final currentBuild = int.tryParse(buildNumber) ?? 0;
    return currentBuild < minimum.buildNumber!;
  }

  static List<int> _parseVersion(String v) {
    final parts = v.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    while (parts.length < 3) {
      parts.add(0);
    }
    return parts.sublist(0, 3);
  }

  static int? _parseBuildNumber(Object? value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return int.tryParse(raw);
  }
}

class _MinimumBuild {
  const _MinimumBuild({required this.version, this.buildNumber});

  final String version;
  final int? buildNumber;

  static _MinimumBuild parse({
    required String? version,
    required int? explicitBuildNumber,
  }) {
    final normalizedVersion = (version ?? '').trim();
    if (normalizedVersion.isEmpty) {
      return _MinimumBuild(version: '0.0.0', buildNumber: explicitBuildNumber);
    }

    final parts = normalizedVersion.split('+');
    final parsedBuild = parts.length > 1 ? int.tryParse(parts[1].trim()) : null;

    return _MinimumBuild(
      version: parts.first.trim(),
      buildNumber: explicitBuildNumber ?? parsedBuild,
    );
  }
}
