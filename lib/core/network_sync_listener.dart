import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'write_queue.dart';

/// Flushes the offline [WriteQueue] when the device regains network access.
class NetworkSyncListener {
  NetworkSyncListener._();

  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static bool _wasOffline = false;

  static Future<void> start() async {
    await stop();

    final connectivity = Connectivity();
    final initial = await connectivity.checkConnectivity();
    _wasOffline = !_isOnline(initial);
    if (!_wasOffline) {
      await WriteQueue.flush();
    }

    _subscription = connectivity.onConnectivityChanged.listen(
      (results) async {
        final online = _isOnline(results);
        if (online && _wasOffline) {
          debugPrint('[NetworkSync] back online — flushing write queue');
          await WriteQueue.flush();
        }
        _wasOffline = !online;
      },
      onError: (e) => debugPrint('[NetworkSync] listener error: $e'),
    );
  }

  static Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  static bool _isOnline(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
