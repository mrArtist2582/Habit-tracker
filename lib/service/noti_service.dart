import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false; // Fixed mutable variable

  bool get isInitialized => _isInitialized;

  // Initialize notifications
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Prepare Android initialization settings
    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Fixed typo

    // Init Settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    // Initialize plugin
    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true; // Mark as initialized

    // Request permission for Android 13+
    await requestPermission();
  }

  // Request notification permission (Android 13+)
  
Future<void> requestPermission() async {
  var status = await Permission.notification.status;

  if (status.isDenied || status.isPermanentlyDenied) {
    await Permission.notification.request();
  }
}

  // Notification details setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily notifications',
        channelDescription: "Daily Notification Channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  // Show notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(), // Pass the correct notification details
    );
  }
}
