enum TaskStatus { todo, doing, done }

enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final TaskPriority priority;
  final List<String> labels;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    List<String>? labels,
    DateTime? createdAt,
    this.dueDate,
  })  : labels = labels ?? [],
        createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    List<String>? labels,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      labels: labels ?? this.labels,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}