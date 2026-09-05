import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notifications.initialize(initializationSettings);

    // Request permission for Android 13+
    await _requestPermissions();
  }

  static Future<bool> _requestPermissions() async {
    try {
      // Request notification permission
      final notificationStatus = await Permission.notification.request();
      
      // Request exact alarms permission for Android 12+
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      
      // Also request through flutter_local_notifications
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
      
      return notificationStatus.isGranted;
    } catch (e) {
      print('Permission request error: $e');
      return false;
    }
  }

  static Future<void> createNotificationChannels() async {
    const AndroidNotificationChannel sugarWarningsChannel = AndroidNotificationChannel(
      'sugar_warnings',
      'Sugar Limit Warnings',
      description: 'Notifications when approaching sugar limits',
      importance: Importance.high,
    );

    const AndroidNotificationChannel dailyRemindersChannel = AndroidNotificationChannel(
      'daily_reminders',
      'Daily Reminders',
      description: 'Daily reminders to track your sugar intake',
      importance: Importance.defaultImportance,
    );

    const AndroidNotificationChannel foodAnalysisChannel = AndroidNotificationChannel(
      'food_analysis',
      'Food Analysis Results',
      description: 'Results from food image analysis',
      importance: Importance.defaultImportance,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(sugarWarningsChannel);
    await androidImplementation?.createNotificationChannel(dailyRemindersChannel);
    await androidImplementation?.createNotificationChannel(foodAnalysisChannel);
  }
}
