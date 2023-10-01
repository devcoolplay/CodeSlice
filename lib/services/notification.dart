
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/services/api_secrets.dart';
import 'package:mobile_app/services/auth.dart';
import 'package:mobile_app/services/database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../screens/home/SettingsTab/appearance.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final AuthService _auth = AuthService();
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => const AppearanceSettings())
      );
    }
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future invalidateToken() async {
    _db.removeNotificationToken(await _messaging.getToken());
    await _messaging.deleteToken();
  }

  Future initNotifications() async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    _db.addNotificationToken(token);
    initPushNotifications();
  }

  String constructShareNotification(String? token, String senderUsername, String snippetTitle) {
    return jsonEncode({
      "to": token,
      "notification": {
        "title": "$senderUsername shared a snippet with you!",
        "body": snippetTitle,
      },
    });
  }

  String constructFriendRequestNotification(String? token, String senderUsername) {
    return jsonEncode({
      "to": token,
      "notification": {
        "title": "$senderUsername sent you a friend request!",
      },
    });
  }

  Future sendShareNotification(String receiverUserId, String senderUsername, String snippetTitle) async {
    List<String> tokenList = await _db.getNotificationTokens(receiverUserId);
    if (tokenList.isEmpty) {
      return;
    }
    for (String token in tokenList) {
      try {
        Response response = await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "key=$cloudMessagingApiKey",
          },
          body: constructShareNotification(token, senderUsername, snippetTitle)
        );
        print(response.body);
      } catch (e) {
        print("Something went wrong while sending notification to $token");
      }
    }
  }

  Future sendFriendRequestNotification(String receiverUserId, String senderUsername) async {
    List<String> tokenList = await _db.getNotificationTokens(receiverUserId);
    if (tokenList.isEmpty) {
      return;
    }
    for (String token in tokenList) {
      try {
        Response response = await http.post(
            Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
              "Authorization": "key=AAAAdnbX3AQ:APA91bE_smGstbQwGBBXNZaZ2HmbUDo5AvO6XJ5s01N8jXGSinXhhkX9trZC5YalBsqyszby_KJEaEyJCPG7h6WFMXat9ce7p7mbOniVW1t78s8UzzKtZmYdy2Td4NMRJz0XpZj8hDlL",
            },
            body: constructFriendRequestNotification(token, senderUsername)
        );
        print(response.body);
      } catch (e) {
        print("Something went wrong while sending notification to $token");
      }
    }
  }
}