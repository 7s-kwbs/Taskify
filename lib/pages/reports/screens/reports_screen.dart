import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/my_task/controllers/task_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/widgets/page_header.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          PageHeader(title: 'Reports', onBack: () => Get.back()),
          Expanded(
            child: Obx(() {
              final tasks = taskController.tasks.toList();
              final completedTasks = tasks
                  .where((task) => task.status == TaskStatus.done)
                  .length;
              final activeTasks = tasks.length - completedTasks;
              final completion = tasks.isEmpty
                  ? 0.0
                  : completedTasks / tasks.length;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total',
                          value: '${tasks.length}',
                          color: const Color(0xFF666AF6),
                          icon: Icons.checklist,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Active',
                          value: '$activeTasks',
                          color: const Color(0xFFFFB347),
                          icon: Icons.pending_actions,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Completed',
                          value: '$completedTasks',
                          color: const Color(0xFF4CAF82),
                          icon: Icons.task_alt,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Completion',
                          value: '${(completion * 100).round()}%',
                          color: const Color(0xFFE4572E),
                          icon: Icons.insights,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ReportSection(
                    title: 'Status overview',
                    children: [
                      _ProgressRow(
                        title: 'To do',
                        count: taskController.todoCount,
                        total: tasks.length,
                        color: const Color(0xFFE4572E),
                      ),
                      _ProgressRow(
                        title: 'Doing',
                        count: taskController.doingCount,
                        total: tasks.length,
                        color: const Color(0xFFFFB347),
                      ),
                      _ProgressRow(
                        title: 'Done',
                        count: taskController.doneCount,
                        total: tasks.length,
                        color: const Color(0xFF4CAF82),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ReportSection(
                    title: 'Priority overview',
                    children: TaskPriority.values
                        .map(
                          (priority) => _ProgressRow(
                            title: _priorityTitle(priority),
                            count: tasks
                                .where((task) => task.priority == priority)
                                .length,
                            total: tasks.length,
                            color: _priorityColor(priority),
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  String _priorityTitle(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color _priorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF4CAF82);
      case TaskPriority.medium:
        return const Color(0xFFFFB347);
      case TaskPriority.high:
        return const Color(0xFFFF6B6B);
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF25343B),
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ReportSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String title;
  final int count;
  final int total;
  final Color color;

  const _ProgressRow({
    required this.title,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : count / total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.blueGrey)),
              Text(
                '$count',
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
