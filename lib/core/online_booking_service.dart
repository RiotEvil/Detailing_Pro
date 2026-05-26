// OnlineBookingService -- background listener stub.
//
// Import logic (booking_request -> order + client) has been moved to the
// backend Cloud Function `onBookingRequestAccepted` which runs with Admin SDK
// and provides idempotent, exactly-once semantics via the `importState` ledger.
//
// This class is kept as a stub so existing call sites in main.dart compile
// without changes. It no longer performs any client-side writes.

import 'package:flutter/foundation.dart';

class OnlineBookingService {
  OnlineBookingService._();

  static bool _started = false;

  static Future<void> start() async {
    if (_started) return;
    _started = true;
    debugPrint('[OnlineBookingService] started (import handled by backend)');
  }

  static Future<void> stop() async {
    _started = false;
    debugPrint('[OnlineBookingService] stopped');
  }
}