import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/labels/controllers/label_controller.dart';
import 'package:todo_app/pages/labels/model/label_model.dart';
import 'package:todo_app/pages/my_task/controllers/task_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/widgets/empty_state.dart';
import 'package:todo_app/widgets/page_header.dart';

class LabelDetail extends StatelessWidget{
  final Label label;

  const LabelDetail({ super.key, required this.label});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          PageHeader(title: label.name, onBack: () => Get.back()),
          Expanded(
            child: Obx(() {
              final tasks = Get.find<TaskController>()
                  .tasks
                  .where((task) => task.labels.contains(label.id))
                  .toList();

              if (tasks.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.label_outline,
                  title: 'No tasks use this label',
                  subtitle: 'Tasks assigned to this label will appear here',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: tasks.length,
                itemBuilder: (context, index) => _LabelTaskCard(task: tasks[index]),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Get.find<LabelController>().deleteLabel(label.id);
                  Get.back();
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete label'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelTaskCard extends StatelessWidget {
  final Task task;

  const _LabelTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final dueDate = task.dueDate == null
        ? 'No due date'
        : DateFormat('dd MMM yyyy').format(task.dueDate!);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Icon(
            task.status == TaskStatus.done
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: task.status == TaskStatus.done
                ? const Color(0xFF4CAF82)
                : Colors.blueGrey,
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
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${task.status.name}  |  $dueDate',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}