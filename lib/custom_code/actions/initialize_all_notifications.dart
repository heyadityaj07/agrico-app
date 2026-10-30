// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

import 'index.dart'; // Imports other custom actions

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Global instance for local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Top-level background handler (Required for Firebase Messaging)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("_firebaseMessagingBackgroundHandler");
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future initializeAllNotifications() async {
  // --- FROM Action 1: initializeFCM ---
  print("HELOOOOOOOO");

  if (!kIsWeb) {
    await Firebase.initializeApp();
  }

  if (kIsWeb) {
    print("FCM not supported on web for local notifications");
    // Even if web, we still run the basic init from Action 2 logic if needed,
    // but the original code returned here.
    return;
  }

  if (!(Platform.isAndroid || Platform.isIOS)) {
    print("Unsupported platform for FCM local notifications");
    return;
  }

  // Request permissions (Combined from Action 1 and Action 2)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Initialize local notifications plugin settings
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  final InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
    macOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification tapped with payload: ${response.payload}");
    },
  );

  // Android notification channel for Oreo+ (Action 1 logic)
  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Subscribe to topic (Action 1 logic)
  try {
    await FirebaseMessaging.instance.subscribeToTopic('all_users');
    print('Subscribed to topic all_users');
  } catch (e) {
    print('Error subscribing to topic: $e');
  }

  // Get device token (Repeated in both Action 1 and Action 2)
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');
  print("FCM Device Token: $token"); // Second print from action 2

  // --- Foreground message handler (Action 1) ---
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground message received');

    RemoteNotification? notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        id: notification.hashCode,
        body: notification.body,
        title: notification.title,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentBadge: true,
            presentSound: true,
            presentAlert: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );

      // Update badge count (Action 1 logic)
      if (Platform.isIOS) {
        FlutterAppBadger.updateBadgeCount(5);
      }
    }
  });

  // When user taps on notification (Action 1)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Notification clicked!');
  });

  // Background message handler (Action 1 & Action 3)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
