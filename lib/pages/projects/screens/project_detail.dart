import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/projects/controllers/project_controller.dart';
import 'package:todo_app/pages/projects/models/project_model.dart';
import 'package:todo_app/pages/projects/screens/add_project_screen.dart';
import 'package:todo_app/pages/projects/screens/add_task_screen.dart';
import 'package:todo_app/pages/projects/tasks/controller/project_task_controller.dart';
import 'package:todo_app/pages/projects/tasks/model/project_task_model.dart';
import 'package:todo_app/widgets/page_header.dart';

class ProjectDetail extends StatefulWidget {
  final Project project;
  const ProjectDetail({super.key, required this.project});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  late final ProjectController _projectController;
  late final ProjectTaskController _taskController;

  @override
  void initState() {
    super.initState();
    _projectController = Get.find<ProjectController>();
    _taskController = Get.find<ProjectTaskController>();
    _taskController.loadTasks(widget.project.id);
  }

  // ── Priority label + color ────────────────────────────────────────
  static const Map<ProjectPriority, String> _priorityLabel = {
    ProjectPriority.low: 'Low',
    ProjectPriority.medium: 'Medium',
    ProjectPriority.high: 'High',
  };

  static const Map<ProjectPriority, Color> _priorityColor = {
    ProjectPriority.low: Color(0xFF4CAF82),
    ProjectPriority.medium: Color(0xFFFFB347),
    ProjectPriority.high: Color(0xFFFF6B6B),
  };

  //Delete project
  void _deleteProject(){
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        title: const Text(
          "Delete Project",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.project.name}"? All tasks inside will also be deleted.',
          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
        ),
        actions: [
          TextButton(
            onPressed: ()=> Get.back(), 
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blueGrey),
            )
          ),
          ElevatedButton(
            onPressed: (){
              Get.back();
              Get.back();
              _projectController.deleteProject(widget.project.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ), 
            child: const Text("Delete")
          )
        ],
      )
    );
  }

  //edit project
  void _editProject(Project project){
    Get.to(()=> AddProjectScreen(existingProject: project));
  }

  Widget _buildActionMenu(Project project){
    return PopupMenuButton(
      icon: const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white24,
        child: Icon(Icons.more_vert, color: Colors.white, size: 20,),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      onSelected: (value){
        if(value == 'edit') _editProject(project);
        if(value == 'delete') _deleteProject();
      },
      itemBuilder: (_)=> [
        const PopupMenuItem(
          value: "edit",
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: Color(0xFF666AF6),),
              SizedBox(width: 10,),
              Text("Edit Project"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFFF6B6B),),
              SizedBox(width: 10,),
              Text("Delete Project", style: TextStyle( color: Color(0xFFFF6B6B)),)
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          // ── Header ──
          Obx((){
            final fresh = _projectController.projects.firstWhere(
              (p)=> p.id == widget.project.id,
              orElse: () => widget.project,
            );
            
          return PageHeader(title: fresh.name,subtitle: "Project Details", onBack: ()=> Get.back(), action: _buildActionMenu(fresh),);
          }
          ),

          // ── Scrollable body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx((){
                    final fresh = _projectController.projects.firstWhere(
                      (p)=> p.id == widget.project.id,
                      orElse: () => widget.project,
                    );
                    return _buildInfoCard(fresh);
                  }),
                  // ── Project info card ──

                  const SizedBox(height: 20),

                  // ── Progress ──
                  Obx(() {
                    final fresh = _projectController.projects.firstWhere(
                      (p) => p.id == widget.project.id,
                      orElse: () => widget.project,
                    );
                    return _buildProgressSection(fresh);
                  }),

                  const SizedBox(height: 24),

                  // ── Task sections ──
                  Obx(
                    () => Column(
                      children: [
                        _buildTaskSection(
                          title: 'Todo',
                          tasks: _taskController.todoTasks,
                          color: const Color(0xFFFF6B6B),
                          icon: Icons.radio_button_unchecked,
                        ),
                        const SizedBox(height: 16),
                        _buildTaskSection(
                          title: 'Doing',
                          tasks: _taskController.doingTasks,
                          color: const Color(0xFFFFB347),
                          icon: Icons.timelapse_rounded,
                        ),
                        const SizedBox(height: 16),
                        _buildTaskSection(
                          title: 'Done',
                          tasks: _taskController.doneTasks,
                          color: const Color(0xFF4CAF82),
                          icon: Icons.check_circle_outline_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Add task FAB ──
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => AddTaskScreen(project: widget.project)),
        backgroundColor: const Color(0xFF666AF6),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ── Project info card ─────────────────────────────────────────────
  Widget _buildInfoCard(Project project) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Description ──
          if (project.description.isNotEmpty) ...[
            Text(
              project.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
                height: 1.5,
              ),
            ),
            const Divider(height: 24),
          ],

          // ── Info rows ──
          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Created',
            value: DateFormat('d MMM yyyy').format(project.createdAt),
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.flag_rounded,
            label: 'Deadline',
            value: DateFormat('d MMM yyyy').format(project.deadline),
            valueColor: project.deadline.isBefore(DateTime.now())
                ? const Color(0xFFFF6B6B)
                : null,
          ),
          const SizedBox(height: 10),

          // ── Priority + color tag row ──
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: 18,
                color: Color(0xFF9E9E9E),
              ),
              const SizedBox(width: 8),
              const Text(
                'Priority',
                style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _priorityColor[project.priority]!.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _priorityLabel[project.priority]!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _priorityColor[project.priority],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // color tag circle
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: project.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Info row ──────────────────────────────────────────────────────
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF9E9E9E)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  // ── Progress section ──────────────────────────────────────────────
  Widget _buildProgressSection(Project project) {
    final ratio = project.totalTasks == 0
        ? 0.0
        : project.completedTasks / project.totalTasks;
    final allDone =
        project.totalTasks > 0 && project.completedTasks == project.totalTasks;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              Text(
                '${project.completedTasks}/${project.totalTasks} done',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: allDone
                      ? const Color(0xFF4CAF82)
                      : const Color(0xFF666AF6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: allDone ? const Color(0xFF4CAF82) : project.color,
            ),
          ),
          if (allDone) ...[
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(
                  Icons.celebration_rounded,
                  size: 16,
                  color: Color(0xFF4CAF82),
                ),
                SizedBox(width: 6),
                Text(
                  'All tasks completed!',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4CAF82),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ── Task section (todo / doing / done) ────────────────────────────
  Widget _buildTaskSection({
    required String title,
    required List<ProjectTask> tasks,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${tasks.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Task cards or empty hint ──
        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No $title tasks',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          )
        else
          ...tasks.map(
            (task) => _TaskCard(
              task: task,
              project: widget.project,
              taskController: _taskController,
            ),
          ),
      ],
    );
  }
}

// ── Task card ─────────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final ProjectTask task;
  final Project project;
  final ProjectTaskController taskController;

  const _TaskCard({
    required this.task,
    required this.project,
    required this.taskController,
  });

  static const Map<ProjectTaskPriority, Color> _priorityColor = {
    ProjectTaskPriority.low: Color(0xFF4CAF82),
    ProjectTaskPriority.medium: Color(0xFFFFB347),
    ProjectTaskPriority.high: Color(0xFFFF6B6B),
  };

  static const Map<ProjectTaskStatus, String> _statusLabel = {
    ProjectTaskStatus.todo: 'Todo',
    ProjectTaskStatus.doing: 'Doing',
    ProjectTaskStatus.done: 'Done',
  };

  static const Map<ProjectTaskStatus, Color> _statusColor = {
    ProjectTaskStatus.todo: Color(0xFFFF6B6B),
    ProjectTaskStatus.doing: Color(0xFFFFB347),
    ProjectTaskStatus.done: Color(0xFF4CAF82),
  };

  void _changeStatus(ProjectTaskStatus newStatus) {
    taskController.updateStatus(project.id, task.id, task.status, newStatus);
  }

  void _deleteTask() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Task',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"?',
          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              taskController.deleteTask(project.id, task.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      // ── Left swipe → status options ──
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.6,
        children: ProjectTaskStatus.values
            .where((s) => s != task.status)
            .map(
              (status) => CustomSlidableAction(
                onPressed: (_) => _changeStatus(status),
                backgroundColor: _statusColor[status]!,
                foregroundColor: Colors.white,
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

      // ── Right swipe → delete ──
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.2,
        children: [
          CustomSlidableAction(
            onPressed: (_) => _deleteTask(),
            backgroundColor: const Color(0xFFFF6B6B),
            foregroundColor: Colors.white,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(14),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline_rounded, size: 22),
                SizedBox(height: 4),
                Text(
                  'Delete',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 5),
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
            // ── Priority color strip ──
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                color: _priorityColor[task.priority],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),

            // ── Title + due date ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: task.status == ProjectTaskStatus.done
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.status == ProjectTaskStatus.done
                          ? Colors.grey
                          : const Color(0xFF25343B),
                    ),
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('d MMM yyyy').format(task.dueDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            task.dueDate!.isBefore(DateTime.now()) &&
                                task.status != ProjectTaskStatus.done
                            ? const Color(0xFFFF6B6B)
                            : Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Labels ──
            if (task.labels.isNotEmpty)
              Wrap(
                spacing: 4,
                children: task.labels
                    .take(2) // max 2 labels shown
                    .map(
                      (label) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF666AF6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF666AF6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
