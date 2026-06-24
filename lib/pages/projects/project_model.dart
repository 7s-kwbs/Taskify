import 'package:flutter/material.dart';

enum ProjectStatus { todo, doing, done }

enum ProjectPriority { low, medium, high }

class Project {
  final String id;
  final String name;
  final String description;
  final DateTime deadline;
  final ProjectPriority priority;
  final Color color;
  final ProjectStatus status;
  final DateTime createdAt;
  final List<String> taskIds;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.color,
    this.status = ProjectStatus.todo,
    DateTime? createdAt,
    List<String>? taskIds,
  }) : createdAt = createdAt ?? DateTime.now(),
       taskIds = taskIds ?? [];

  Project copywith({
    String? name,
    String? description,
    DateTime? deadline,
    ProjectPriority? priority,
    Color? color,
    ProjectStatus? status,
    List<String>? taskIds,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      status: status ?? this.status,
      createdAt: createdAt,
      taskIds: taskIds ?? this.taskIds,
    );
  }
}
