import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'access_guard.dart';
import 'notification_center.dart';

class OrderReminderService {
  OrderReminderService._();

  static bool _initialized = false;
  static bool _syncInProgress = false;
  static int? _lastSyncHash;
  static const List<Duration> _leadTimes = [
    Duration(days: 1),
    Duration(hours: 2),
    Duration(hours: 1),
  ];

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    try {
      final dynamic localTz = await FlutterTimezone.getLocalTimezone();
      String? timezoneName;
      if (localTz is String) {
        timezoneName = localTz;
      } else {
        final identifier = (localTz as dynamic).identifier;
        if (identifier is String) {
          timezoneName = identifier;
        }
      }
      if (timezoneName != null && timezoneName.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(timezoneName));
      } else {
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    _initialized = true;
  }

  static Future<void> scheduleForOrder({
    required Map<String, dynamic> order,
    required AppLocalizations l10n,
  }) async {
    if (!AccessGuard.canUseAutomatedReminders()) {
      await cancelForOrder(order['id']?.toString());
      return;
    }

    await ensureInitialized();

    final orderId = order['id']?.toString();
    if (orderId == null || orderId.isEmpty) return;

    await cancelForOrder(orderId);

    final rawDate = order['scheduledDate'];
    if (rawDate is! num) {
      return;
    }

    final scheduledAt = DateTime.fromMillisecondsSinceEpoch(rawDate.toInt());
    final timeLabel =
        order['scheduledTime']?.toString().trim().isNotEmpty == true
        ? order['scheduledTime'].toString()
        : '${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}';

    final nowCutoff = DateTime.now().add(const Duration(seconds: 20));
    for (var index = 0; index < _leadTimes.length; index++) {
      final remindAt = scheduledAt.subtract(_leadTimes[index]);
      if (remindAt.isBefore(nowCutoff)) {
        continue;
      }

      await appNotifications.zonedSchedule(
        _notificationId(orderId, index),
        l10n.appointmentReminderTitle,
        l10n.appointmentReminderBody(
          order['car']?.toString() ?? l10n.orderDefaultTitle,
          timeLabel,
        ),
        tz.TZDateTime.from(remindAt, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'appointments_reminder_channel',
            l10n.ordersChannelName,
            channelDescription: l10n.ordersChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            icon: 'ic_launcher_foreground',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: orderId,
      );
    }
  }

  static Future<void> syncForOrders({
    required Iterable<Map<String, dynamic>> orders,
    required AppLocalizations l10n,
  }) async {
    if (!AccessGuard.canUseAutomatedReminders()) {
      for (final order in orders) {
        await cancelForOrder(order['id']?.toString());
      }
      return;
    }

    final snapshot =
        orders
            .map(
              (order) => [
                order['id']?.toString() ?? '',
                order['status']?.toString() ?? '',
                order['scheduledDate']?.toString() ?? '',
                order['scheduledTime']?.toString() ?? '',
              ].join('|'),
            )
            .toList()
          ..sort();
    final syncHash = Object.hashAll(snapshot);

    if (_syncInProgress || _lastSyncHash == syncHash) {
      return;
    }

    _syncInProgress = true;
    _lastSyncHash = syncHash;
    try {
      for (final order in orders) {
        final status = order['status']?.toString() ?? '';
        if (status == 'completed' || status == 'paid') {
          await cancelForOrder(order['id']?.toString());
          continue;
        }
        await scheduleForOrder(order: order, l10n: l10n);
      }
    } finally {
      _syncInProgress = false;
    }
  }

  static Future<void> cancelForOrder(String? orderId) async {
    if (orderId == null || orderId.isEmpty) return;
    await appNotifications.cancel(_legacyNotificationId(orderId));
    for (var index = 0; index < _leadTimes.length; index++) {
      await appNotifications.cancel(_notificationId(orderId, index));
    }
  }

  static int _legacyNotificationId(String orderId) {
    return orderId.hashCode & 0x7fffffff;
  }

  static int _notificationId(String orderId, int slotIndex) {
    return '$orderId#$slotIndex'.hashCode & 0x7fffffff;
  }
}
