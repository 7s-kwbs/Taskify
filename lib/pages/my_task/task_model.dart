 
import 'dart:ui';

class TaskLabel {
  final String text;
  final Color color;
  const TaskLabel(this.text, this.color);
}

class TaskItem {
  final String title;
  final String date;
  final List<TaskLabel> labels;
  final bool isCompleted;
  final bool isHabit;
 
  const TaskItem({
    required this.title,
    required this.date,
    this.labels = const [],
    this.isCompleted = false,
    this.isHabit = false,
  });
}