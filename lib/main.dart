import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mega_plus/app_root.dart';
import 'package:mega_plus/core/helpers/cache/cache_helper.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';

// Initialize Flutter Local Notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling background message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
  }
  // Background notifications are automatically shown by Firebase
  // No need to manually show them here
}

// Show local notification
Future<void> _showLocalNotification(RemoteMessage message) async {
  try {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // channel id
      'High Importance Notifications', // channel name
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new message',
      platformChannelSpecifics,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error showing local notification: $e');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Firebase.initializeApp(),
    CacheHelper.init(),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  // Initialize local notifications
  try {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) {
          print('Notification tapped: ${response.payload}');
        }
        // Handle notification tap
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing local notifications: $e');
    }
    // Continue without local notifications - Firebase will handle background notifications
  }

  // Set up Firebase Messaging
  final messaging = FirebaseMessaging.instance;

  // Request notification permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Notification permission status: ${settings.authorizationStatus}');
  }

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Received foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification body: ${message.notification?.body}');
    }
    // Show local notification for foreground messages
    _showLocalNotification(message);
  });

  // Handle notification taps when app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Notification opened app: ${message.messageId}');
      print('Message data: ${message.data}');
    }
    // Handle navigation based on notification data
  });

  // Check if app was opened from a terminated state via notification
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    if (kDebugMode) {
      print('App opened from terminated state via notification: ${initialMessage.messageId}');
      print('Message data: ${initialMessage.data}');
    }
    // Handle navigation based on notification data
  }

  // Get and log Firebase token
  try {
    final token = await messaging.getToken();
    if (kDebugMode) {
      print('Firebase Token: $token');
    }

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) {
      if (kDebugMode) {
        print('Firebase Token refreshed: $newToken');
      }
      // You can send the new token to your server here
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error getting Firebase token: $e');
    }
  }

  DioHelper.init();
  runApp(const AppRoot());
}
