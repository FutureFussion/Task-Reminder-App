import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduleTaskNotification(Task task) async {
    await _cancelTaskNotifications(task.id);

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      task.time.hour,
      task.time.minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    print('Scheduling notification for ${task.name} at $scheduledDate');

    switch (task.repeatType) {
      case RepeatType.none:
        await _scheduleNotification(
          task.id.hashCode,
          'Task Reminder',
          'Time to complete: ${task.name}',
          scheduledDate,
          task.id,
        );
        break;

      case RepeatType.daily:
        // For daily tasks, schedule the first one and then use repeating
        await _scheduleNotification(
          task.id.hashCode,
          'Daily Task Reminder',
          'Time to complete: ${task.name}',
          scheduledDate,
          task.id,
        );

        // Schedule additional daily notifications
        for (int i = 1; i <= 30; i++) {
          final nextDate = scheduledDate.add(Duration(days: i));
          await _scheduleNotification(
            task.id.hashCode + i,
            'Daily Task Reminder',
            'Time to complete: ${task.name}',
            nextDate,
            task.id,
          );
        }
        break;

      case RepeatType.weekly:
        // For weekly tasks, schedule multiple weeks
        for (int i = 0; i < 12; i++) {
          final nextDate = scheduledDate.add(Duration(days: i * 7));
          await _scheduleNotification(
            task.id.hashCode + i,
            'Weekly Task Reminder',
            'Time to complete: ${task.name}',
            nextDate,
            task.id,
          );
        }
        break;
    }
  }

  Future<void> _scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
    String taskId,
  ) async {
    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_channel',
            'Task Reminders',
            channelDescription: 'Notifications for task reminders',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: taskId,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );
      print('Notification scheduled successfully for $scheduledDate');
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> _cancelTaskNotifications(String taskId) async {
    // Cancel main notification
    await _notifications.cancel(taskId.hashCode);

    // Cancel additional notifications for repeating tasks
    for (int i = 1; i <= 30; i++) {
      await _notifications.cancel(taskId.hashCode + i);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  void _onNotificationTapped(NotificationResponse details) {
    print('Notification tapped with payload: ${details.payload}');
    if (details.payload != null) {
      onNotificationTapped?.call(details.payload!);
    }
  }

  Function(String taskId)? onNotificationTapped;

  // Test notification method
  Future<void> scheduleTestNotification() async {
    final now = DateTime.now();
    final testTime = now.add(const Duration(seconds: 5));

    await _notifications.zonedSchedule(
      999,
      'Test Notification',
      'This is a test notification',
      tz.TZDateTime.from(testTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Notifications for task reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }
}
