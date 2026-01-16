import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const String _channelId = 'engagement_updates';
  static const int _paymentNotificationId = 30000;
  static bool _initialized = false;

  static const String _fallbackChannelName = 'Engagement updates';
  static const String _fallbackChannelDescription =
      'Keeps you informed about bookmarks, requests, and payments.';

  static NotificationDetails _notificationDetails(S l10n) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        l10n.Engagementupdates,
        channelDescription: l10n.RevisitYourBookMarked,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static Future<void> init() async {
    if (_initialized) return;

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    const channel = AndroidNotificationChannel(
      _channelId,
      _fallbackChannelName,
      description: _fallbackChannelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  static Future<void> notifyRequestConfirmed(
    BuildContext context,
    String officeName,
  ) async {
    final l10n = S.of(context);
    final body = officeName.isNotEmpty
        ? '${l10n.TakeAnotherLook} $officeName'
        : l10n.RevisitYourBookMarked;
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      l10n.RequestConfirmed,
      body,
      _notificationDetails(l10n),
    );
  }

  static Future<void> notifyPaymentStatus(
    BuildContext context, {
    required bool success,
    String? planName,
  }) async {
    final l10n = S.of(context);
    final title = success ? l10n.PaymentVefified : l10n.PaymentFailed;
    final body = success
        ? '${planName ?? l10n.Plans} • ${l10n.PaymentSuccessfull}'
        : l10n.PaymentStillProcessing;
    await _plugin.show(
      _paymentNotificationId,
      title,
      body,
      _notificationDetails(l10n),
    );
  }

}
