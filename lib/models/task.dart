import 'dart:convert';

enum RepeatType { none, daily, weekly }

class Task {
  final String id;
  final String name;
  final String description;
  final RepeatType repeatType;
  final DateTime time;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.repeatType,
    required this.time,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'repeatType': repeatType.index,
      'time': time.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      repeatType: RepeatType.values[json['repeatType']],
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  String toJsonString() => json.encode(toJson());
  
  factory Task.fromJsonString(String jsonString) => 
      Task.fromJson(json.decode(jsonString));
}

class TaskResponse {
  final String id;
  final String taskId;
  final String taskName;
  final bool completed;
  final DateTime timestamp;

  TaskResponse({
    required this.id,
    required this.taskId,
    required this.taskName,
    required this.completed,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'taskName': taskName,
      'completed': completed,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      id: json['id'],
      taskId: json['taskId'],
      taskName: json['taskName'],
      completed: json['completed'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  String toJsonString() => json.encode(toJson());
  
  factory TaskResponse.fromJsonString(String jsonString) => 
      TaskResponse.fromJson(json.decode(jsonString));
}