import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<TaskResponse> _responses = [];

  List<Task> get tasks => _tasks;
  List<TaskResponse> get responses => _responses;

  TaskProvider() {
    _loadTasks();
    _loadResponses();
    NotificationService().onNotificationTapped = _handleNotificationTap;
  }

  Future<void> _loadTasks() async {
    _tasks = await StorageService.getTasks();
    notifyListeners();
  }

  Future<void> _loadResponses() async {
    _responses = await StorageService.getTaskResponses();
    _responses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await StorageService.saveTask(task);
    await NotificationService().scheduleTaskNotification(task);
    await _loadTasks();
    print('Task added and notification scheduled: ${task.name}');
  }

  Future<void> deleteTask(String taskId) async {
    await StorageService.deleteTask(taskId);
    // Cancel notifications for this task
    await NotificationService().cancelAllNotifications();
    await _loadTasks();
  }

  Future<void> addTaskResponse(TaskResponse response) async {
    await StorageService.saveTaskResponse(response);
    await _loadResponses();
    // Notify listeners immediately to update analytics
    notifyListeners();
    print('Task response added: ${response.taskName} - ${response.completed}');
  }

  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  void _handleNotificationTap(String taskId) {
    print('Handling notification tap for task: $taskId');
    final task = getTaskById(taskId);
    if (task != null) {
      onTaskNotificationTapped?.call(task);
    }
  }

  Function(Task task)? onTaskNotificationTapped;

  List<TaskResponse> getResponsesForLast7Days() {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return _responses
        .where((response) => response.timestamp.isAfter(sevenDaysAgo))
        .toList();
  }

  Map<DateTime, List<TaskResponse>> getResponsesByDay() {
    final responsesByDay = <DateTime, List<TaskResponse>>{};

    for (final response in _responses) {
      final date = DateTime(
        response.timestamp.year,
        response.timestamp.month,
        response.timestamp.day,
      );

      if (!responsesByDay.containsKey(date)) {
        responsesByDay[date] = [];
      }
      responsesByDay[date]!.add(response);
    }

    return responsesByDay;
  }

  // Get completion rate for analytics
  double getCompletionRate() {
    if (_responses.isEmpty) return 0.0;
    final completedCount = _responses.where((r) => r.completed).length;
    return completedCount / _responses.length;
  }

  // Get today's responses
  List<TaskResponse> getTodayResponses() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return _responses
        .where((response) =>
            response.timestamp.isAfter(today) &&
            response.timestamp.isBefore(tomorrow))
        .toList();
  }
}
