import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'fcm_config.dart';

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  String? _token;

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
    });
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
