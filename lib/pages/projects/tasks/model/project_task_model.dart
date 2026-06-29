enum ProjectTaskStatus { todo, doing, done }

enum ProjectTaskPriority { low, medium, high }

class ProjectTask {
  final String id;
  final String title;
  final String description;
  final ProjectTaskStatus status;
  final ProjectTaskPriority priority;
  final String projectId;
  final List<String> labels;
  final DateTime createdAt;
  final DateTime? dueDate;

  ProjectTask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.projectId,
    List<String>? labels,
    DateTime? createdAt,
    this.dueDate,
  }) : labels = labels ?? [],
       createdAt = createdAt ?? DateTime.now();

  ProjectTask copyWith({
    String? title,
    String? description,
    ProjectTaskStatus? status,
    ProjectTaskPriority? priority,
    String? projectId,
    List<String>? labels,
    DateTime? dueDate,
  }){
    return ProjectTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      labels: labels ?? this.labels,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
