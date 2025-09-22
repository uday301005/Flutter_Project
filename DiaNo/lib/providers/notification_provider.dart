import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _notificationsEnabled = true;
  bool _dailyRemindersEnabled = true;
  bool _limitWarningsEnabled = true;
  String _dailyReminderTime = '09:00';

  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyRemindersEnabled => _dailyRemindersEnabled;
  bool get limitWarningsEnabled => _limitWarningsEnabled;
  String get dailyReminderTime => _dailyReminderTime;

  NotificationProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    _dailyRemindersEnabled = prefs.getBool('daily_reminders_enabled') ?? true;
    _limitWarningsEnabled = prefs.getBool('limit_warnings_enabled') ?? true;
    _dailyReminderTime = prefs.getString('daily_reminder_time') ?? '09:00';
    notifyListeners();
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    _notificationsEnabled = enabled;
    notifyListeners();
  }

  Future<void> updateDailyRemindersEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminders_enabled', enabled);
    _dailyRemindersEnabled = enabled;
    notifyListeners();
  }

  Future<void> updateLimitWarningsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('limit_warnings_enabled', enabled);
    _limitWarningsEnabled = enabled;
    notifyListeners();
  }

  Future<void> updateDailyReminderTime(String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('daily_reminder_time', time);
    _dailyReminderTime = time;
    notifyListeners();
  }

  Future<bool> requestPermissions() async {
    try {
      // Check current permission status
      final notificationStatus = await Permission.notification.status;
      
      if (notificationStatus.isGranted) {
        return true;
      }
      
      // Request notification permission
      final notificationResult = await Permission.notification.request();
      
      // Request exact alarms permission for Android 12+
      await Permission.scheduleExactAlarm.request();
      
      // Also request through flutter_local_notifications
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
      
      return notificationResult.isGranted;
    } catch (e) {
      print('Permission request error: $e');
      return false;
    }
  }

  Future<void> showSugarLimitWarning(double currentIntake, double limit) async {
    if (!_notificationsEnabled || !_limitWarningsEnabled) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'sugar_warnings',
      'Sugar Limit Warnings',
      channelDescription: 'Notifications when approaching sugar limits',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final percentage = (currentIntake / limit * 100).round();
    String message;
    
    if (percentage >= 100) {
      message = '⚠️ You have exceeded your daily sugar limit!';
    } else if (percentage >= 80) {
      message = '⚠️ You are approaching your daily sugar limit (${percentage}%)';
    } else if (percentage >= 60) {
      message = '📊 You have consumed ${percentage}% of your daily sugar limit';
    } else {
      return; // Don't show notification for low percentages
    }

    await _notifications.show(
      1,
      'Sugar Meter Alert',
      message,
      notificationDetails,
    );
  }

  Future<void> showDailyReminder() async {
    if (!_notificationsEnabled || !_dailyRemindersEnabled) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminders',
      'Daily Reminders',
      channelDescription: 'Daily reminders to track your sugar intake',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      2,
      'Daily Sugar Tracking',
      'Don\'t forget to track your sugar intake today! 🍎',
      notificationDetails,
    );
  }

  Future<void> showFoodAnalysisResult(String foodName, double sugarContent) async {
    if (!_notificationsEnabled) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'food_analysis',
      'Food Analysis Results',
      channelDescription: 'Results from food image analysis',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      3,
      'Food Analysis Complete',
      'Detected: $foodName\nSugar: ${sugarContent.toStringAsFixed(1)}g',
      notificationDetails,
    );
  }

  Future<void> scheduleDailyReminder() async {
    if (!_dailyRemindersEnabled) return;

    final timeParts = _dailyReminderTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminders',
      'Daily Reminders',
      channelDescription: 'Daily reminders to track your sugar intake',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      2,
      'Daily Sugar Tracking',
      'Don\'t forget to track your sugar intake today! 🍎',
      tz.TZDateTime.from(_nextInstanceOfTime(hour, minute), tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  DateTime _nextInstanceOfTime(int hour, int minute) {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }
}
