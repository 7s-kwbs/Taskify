import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/labels/controllers/label_controller.dart';
import 'package:todo_app/pages/my_task/controllers/task_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/pages/my_task/screens/add_independent_task_screen.dart';
import 'package:todo_app/widgets/bottom_nav.dart';
import 'package:todo_app/widgets/empty_state.dart';
import 'package:todo_app/widgets/page_header.dart';

class MytaskScreen extends StatelessWidget {
  const MytaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find<TaskController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          PageHeader(title: "My Tasks", onBack: () => Get.back()),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Stack(
                children: [
                  Obx(
                    () => ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      children: [
                        ..._buildTaskSection(
                          title: 'No due date',
                          tasks: taskController.noDueDateTasks,
                          taskController: taskController,
                        ),
                        ..._buildTaskSection(
                          title: 'Today',
                          tasks: taskController.todayTasks,
                          taskController: taskController,
                        ),
                        ..._buildTaskSection(
                          title: 'Tomorrow',
                          tasks: taskController.tomorrowTasks,
                          taskController: taskController,
                        ),
                        ..._buildTaskSection(
                          title: 'This week',
                          tasks: taskController.thisWeekTasks,
                          taskController: taskController,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 150,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.8),
                            ],
                            stops: const [0.0, 0.4, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomNav(),
        ],
      ),
    );
  }

  List<Widget> _buildTaskSection({
    required String title,
    required List<Task> tasks,
    required TaskController taskController,
  }) {
    return [
      _SectionHeader(title: title),
      const SizedBox(height: 5),
      if (tasks.isEmpty)
        EmptyStateWidget(
          icon: Icons.inbox_outlined,
          title: 'No $title tasks',
          subtitle: 'Tasks scheduled for this period will appear here',
        )
      else
        ...tasks.map(
          (task) => _TaskCard(task: task, taskController: taskController),
        ),
      const SizedBox(height: 12),
    ];
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final TaskController taskController;

  const _TaskCard({required this.task, required this.taskController});

  static const Map<TaskStatus, String> _statusLabel = {
    TaskStatus.todo: 'To do',
    TaskStatus.doing: 'Doing',
    TaskStatus.done: 'Done',
  };

  static const Map<TaskStatus, Color> _statusColor = {
    TaskStatus.todo: Color(0xFFFF6B6B),
    TaskStatus.doing: Color(0xFFFFB347),
    TaskStatus.done: Color(0xFF4CAF82),
  };

  void _changeStatus(TaskStatus status) {
    taskController.updateStatus(task.id, task.status, status);
  }

  void _deleteTask() {
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
    final labelController = Get.find<LabelController>();

    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: TaskStatus.values
            .where((status) => status != task.status)
            .map(
              (status) => CustomSlidableAction(
                onPressed: (_) => _changeStatus(status),
                backgroundColor: Colors.transparent,
                foregroundColor: _statusColor[status],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.swap_horiz_rounded, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      _statusLabel[status]!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        children: [
          CustomSlidableAction(
            onPressed: (_) =>
                Get.to(() => AddIndependentTaskScreen(existingTask: task)),
            backgroundColor: Colors.transparent,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 22, color: Colors.blue),
                SizedBox(height: 4),
                Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          CustomSlidableAction(
            onPressed: (_) => _deleteTask(),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: Offset(0, 2),
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
                      color: Color.fromARGB(255, 37, 52, 59),
                      height: 1.2,
                    ),
                  ),
                  Text(
                    task.dueDate == null
                        ? 'No due date'
                        : DateFormat('dd MMM yyyy').format(task.dueDate!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            if (task.labels.isNotEmpty)
              Wrap(
                spacing: 4,
                children: task.labels
                    .take(2)
                    .map(
                      (labelId) => _LabelChip(
                        text: labelController.getNameById(labelId),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String text;
  const _LabelChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: Colors.blueGrey,
      ),
    );
  }
}
