import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/labels/controllers/label_controller.dart';
import 'package:todo_app/pages/labels/model/label_model.dart';
import 'package:todo_app/pages/labels/screeens/add_label_screen.dart';
import 'package:todo_app/pages/labels/screeens/label_detail_screen.dart';
import 'package:todo_app/pages/calendar/screens/calendar_screen.dart';
import 'package:todo_app/pages/my_task/controllers/task_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/pages/my_task/screens/my_task_screen.dart';
import 'package:todo_app/pages/projects/controllers/project_controller.dart';
import 'package:todo_app/pages/projects/models/project_model.dart';
import 'package:todo_app/pages/projects/screens/add_project_screen.dart';
import 'package:todo_app/pages/projects/screens/project_detail.dart';
import 'package:todo_app/pages/projects/tasks/controller/project_task_controller.dart';
import 'package:todo_app/pages/reports/screens/reports_screen.dart';
import 'package:todo_app/pages/settings/settings_screen.dart';
import 'package:todo_app/widgets/dashboard_header.dart';
import 'package:todo_app/pages/dashboard/status_detail_screen.dart';
import 'package:todo_app/widgets/empty_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool projectExpanded = true;
  bool labelsExpanded = true;
  bool statusExpanded = true;

  late final ProjectController _projectController;
  final labelController = Get.put(LabelController());

  @override
  void initState() {
    super.initState();
    _projectController = Get.put(ProjectController(), permanent: false);
    Get.put(ProjectTaskController(), permanent: false);
    Get.put(TaskController(), permanent: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          DashboardHeader(onSettingsTap: () => Get.to(SettingsScreen())),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // ── View cards ──
                  Row(
                    children: [
                      Expanded(
                        child: _dashboardCard(
                          title: "List",
                          icon: Icons.list_outlined,
                          onTap: () => Get.to(() => MytaskScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dashboardCard(
                          title: "Calendar",
                          icon: Icons.calendar_month,
                          onTap: () => Get.to(() => const CalendarScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dashboardCard(
                          title: "Reports",
                          icon: Icons.view_kanban,
                          onTap: () => Get.to(() => const ReportsScreen()),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Projects section ──
                  SectionHeader(
                    title: "Projects",
                    expanded: projectExpanded,
                    onToggle: () =>
                        setState(() => projectExpanded = !projectExpanded),
                    onAdd: () => Get.to(() => const AddProjectScreen()),
                  ),
                  if (projectExpanded) _buildProjectsList(),

                  // ── Labels section ──
                  SectionHeader(
                    title: "Labels",
                    expanded: labelsExpanded,
                    onToggle: () =>
                        setState(() => labelsExpanded = !labelsExpanded),
                    onAdd: () => Get.to(() => AddLabelScreen()),
                  ),
                  if (labelsExpanded)
                    Obx(() {
                      final labels = labelController.labels.toList();
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final chipWidth = (constraints.maxWidth - 10) / 2;
                          return Wrap(
                            spacing: 10,
                            runSpacing: 14,
                            children: labels
                                .map(
                                  (label) => SizedBox(
                                    width: chipWidth,
                                    child: Labelchip(
                                      color: label.color,
                                      title: label.name,
                                      label: label,
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      );
                    }),

                  // ── Status section ──
                  SectionHeader(
                    title: "Status",
                    expanded: statusExpanded,
                    onToggle: () =>
                        setState(() => statusExpanded = !statusExpanded),
                    onAdd: () {},
                  ),
                  if (statusExpanded)
                    Obx(() {
                      final taskController = Get.find<TaskController>();
                      return Row(
                        children: [
                          Expanded(
                            child: StatusChip(
                              color: const Color(0xFFE4572E),
                              title: "To do",
                              count: taskController.todoCount,
                              status: TaskStatus.todo,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatusChip(
                              color: const Color(0xFFFFB347),
                              title: "Doing",
                              count: taskController.doingCount,
                              status: TaskStatus.doing,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatusChip(
                              color: const Color(0xFF4CAF82),
                              title: "Done",
                              count: taskController.doneCount,
                              status: TaskStatus.done,
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Projects list with three states ──────────────────────────────
  Widget _buildProjectsList() {
    return Obx(() {
      // loading state
      // if (_projectController.isLoading.value) {
      //   return const Padding(
      //     padding: EdgeInsets.symmetric(vertical: 24),
      //     child: Center(
      //       child: CircularProgressIndicator(color: Color(0xFF666AF6)),
      //     ),
      //   );
      // }

      // empty state
      if (_projectController.projects.isEmpty) {
        return EmptyStateWidget(
          icon: Icons.folder_open_outlined,
          title: 'No projects yet',
          subtitle: 'Create your first project to get started',
          actionLabel: 'Add project',
          onAction: () => Get.to(() => const AddProjectScreen()),
        );
      }

      // has data
      return Column(
        children: _projectController.projects
            .map(
              (project) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ProjectCard(project: project),
              ),
            )
            .toList(),
      );
    });
  }

  // ── Dashboard card ────────────────────────────────────────────────
  Widget _dashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D2974),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: const Color(0xFF666AF6), size: 42),
          ),
        ),
      ],
    );
  }
}

// ── ProjectCard ────────────────────────────────────────────────────
class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final projectController = Get.find<ProjectController>();

    return Obx(() {
      final fresh = projectController.projects.firstWhere(
        (p) => p.id == project.id,
        orElse: () => project,
      );
      final progress = '${fresh.completedTasks}/${fresh.totalTasks}';
      final bool allDone =
          fresh.totalTasks > 0 && fresh.completedTasks == fresh.totalTasks;

      return InkWell(
        onTap: () => Get.to(() => ProjectDetail(project: fresh)),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              // ── Color tag indicator ──
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: fresh.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // ── Icon ──
              Icon(Icons.assignment_sharp, color: project.color, size: 28),
              const SizedBox(width: 12),

              // ── Name + progress bar ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fresh.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                    ),
                    if (fresh.totalTasks > 0) ...[
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: fresh.completedTasks / fresh.totalTasks,
                        backgroundColor: Colors.grey.shade200,
                        color: allDone ? const Color(0xFF4CAF82) : fresh.color,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 4,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // ── Progress label ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (fresh.hasPendingWrites)
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 14,
                      color: Colors.orange.shade400,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    progress,
                    style: TextStyle(
                      fontSize: 14,
                      color: allDone
                          ? const Color(0xFF4CAF82)
                          : Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ── StatusChip ─────────────────────────────────────────────────────
class StatusChip extends StatelessWidget {
  final Color color;
  final String title;
  final int count;
  final TaskStatus status;

  const StatusChip({
    super.key,
    required this.color,
    required this.title,
    required this.count,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => StatusDetailScreen(status: status)),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Labelchip ──────────────────────────────────────────────────────
class Labelchip extends StatelessWidget {
  final Label label;
  final String title;
  final Color color;

  const Labelchip({
    super.key,
    required this.label,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => LabelDetail(label: label)),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
            Icon(Icons.local_offer_outlined, color: color, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            // Text(
            //   '$count',
            //   style: TextStyle(
            //     fontSize: 15,
            //     color: Colors.grey.shade400,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// ── SectionHeader ──────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onAdd;

  const SectionHeader({
    super.key,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onToggle,
              icon: AnimatedRotation(
                turns: expanded ? 0 : -0.25,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade500,
                  size: 32,
                ),
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: Icon(Icons.add, color: Colors.grey.shade500, size: 26),
            ),
          ],
        ),
      ],
    );
  }
}
