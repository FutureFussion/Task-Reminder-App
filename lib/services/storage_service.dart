import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _responsesKey = 'task_responses';

  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson.map((taskJson) => Task.fromJsonString(taskJson)).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJsonString()).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  static Future<void> saveTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  static Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  static Future<List<TaskResponse>> getTaskResponses() async {
    final prefs = await SharedPreferences.getInstance();
    final responsesJson = prefs.getStringList(_responsesKey) ?? [];
    return responsesJson.map((responseJson) => TaskResponse.fromJsonString(responseJson)).toList();
  }

  static Future<void> saveTaskResponse(TaskResponse response) async {
    final responses = await getTaskResponses();
    responses.add(response);
    await saveTaskResponses(responses);
  }

  static Future<void> saveTaskResponses(List<TaskResponse> responses) async {
    final prefs = await SharedPreferences.getInstance();
    final responsesJson = responses.map((response) => response.toJsonString()).toList();
    await prefs.setStringList(_responsesKey, responsesJson);
  }
}