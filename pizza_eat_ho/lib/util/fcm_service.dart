import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'fcm_config.dart';

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  String? _token;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _localNotificationsInitialized = false;

  String? get token => _token;

  Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission();

    _token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM token: $_token');
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      _token = token;
      debugPrint('FCM token refreshed: $token');
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('FCM message: ${message.messageId}');
      _showForegroundNotification(message);
    });
  }

  Future<String?> ensureToken() async {
    if (_token != null && _token!.isNotEmpty) {
      return _token;
    }
    _token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM token: $_token');
    return _token;
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    await _ensureLocalNotificationsInitialized();

    final notification = message.notification;
    if (notification == null) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'order_updates',
      'Order Updates',
      channelDescription: 'Notifications for order updates',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }

  Future<void> _ensureLocalNotificationsInitialized() async {
    if (_localNotificationsInitialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initSettings);
    _localNotificationsInitialized = true;
  }

  Future<void> sendOrderReadyPush({String? orderId}) async {
    if (fcmServerKey.startsWith('REPLACE_')) {
      debugPrint('FCM server key not set. Skipping push send.');
      return;
    }

    final token = _token;
    if (token == null) {
      debugPrint('FCM token not available. Skipping push send.');
      return;
    }

    final payload = <String, dynamic>{
      'to': token,
      'notification': {
        'title': '주문 완료',
        'body': '상품이 준비됐습니다.',
      },
      'data': {
        'type': 'order_ready',
        if (orderId != null) 'orderId': orderId,
      },
    };

    final response = await http.post(
      Uri.parse(fcmApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmServerKey',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 400) {
      throw Exception('FCM send failed: ${response.statusCode} ${response.body}');
    }
  }
}
