import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/my_task/controllers/task_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/widgets/empty_state.dart';
import 'package:todo_app/widgets/page_header.dart';

class StatusDetailScreen extends StatelessWidget {
  final TaskStatus status;

  const StatusDetailScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          PageHeader(title: _statusTitle(status), onBack: () => Get.back()),
          Obx(() {
            final count = taskController.tasks
                .where((task) => task.status == status)
                .length;
            if (count == 0) return const SizedBox.shrink();

            return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: TextButton.icon(
                  onPressed: () => _confirmClearAll(taskController),
                  icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                  label: const Text('Clear all'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              final tasks = taskController.tasks
                  .where((task) => task.status == status)
                  .toList();

              if (tasks.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.task_alt_outlined,
                  title: 'No ${_statusTitle(status)} tasks',
                  subtitle: 'Tasks with this status will appear here',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: tasks.length,
                itemBuilder: (context, index) => _TaskStatusCard(
                  task: tasks[index],
                  taskController: taskController,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _statusTitle(TaskStatus value) {
    switch (value) {
      case TaskStatus.todo:
        return 'To do';
      case TaskStatus.doing:
        return 'Doing';
      case TaskStatus.done:
        return 'Done';
    }
  }

  void _confirmClearAll(TaskController taskController) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear all tasks'),
        content: Text(
          'Delete all ${_statusTitle(status).toLowerCase()} independent tasks?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final tasks = taskController.tasks
                  .where((task) => task.status == status)
                  .toList();
              await taskController.deleteTasks(tasks);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }
}

class _TaskStatusCard extends StatelessWidget {
  final Task task;
  final TaskController taskController;

  const _TaskStatusCard({required this.task, required this.taskController});

  void _confirmDelete() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              taskController.deleteTask(task.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dueDate = task.dueDate == null
        ? 'No due date'
        : DateFormat('dd MMM yyyy').format(task.dueDate!);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            onPressed: (_) => _confirmDelete(),
            backgroundColor: Colors.transparent,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, size: 22, color: Colors.red),
                SizedBox(height: 4),
                Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          children: [
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                color: _statusColor[task.status],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF25343B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dueDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (task.labels.isNotEmpty)
              Wrap(
                spacing: 4,
                children: task.labels
                    .take(2)
                    .map((label) => _LabelChip(text: label))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  static const Map<TaskStatus, Color> _statusColor = {
    TaskStatus.todo: Color(0xFFFF6B6B),
    TaskStatus.doing: Color(0xFFFFB347),
    TaskStatus.done: Color(0xFF4CAF82),
  };
}

class _LabelChip extends StatelessWidget {
  final String text;

  const _LabelChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF666AF6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF666AF6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
