import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/dashboard/label_item_model.dart';
import 'package:todo_app/pages/dashboard/status_item_model.dart';
import 'package:todo_app/pages/labels/add_label_screen.dart';
import 'package:todo_app/pages/labels/label_detail_screen.dart';
import 'package:todo_app/pages/my_task/my_task_screen.dart';
import 'package:todo_app/pages/projects/controllers/project_controller.dart';
import 'package:todo_app/pages/projects/models/project_model.dart';
import 'package:todo_app/pages/projects/screens/add_project_screen.dart';
import 'package:todo_app/pages/projects/screens/project_detail.dart';
import 'package:todo_app/pages/projects/tasks/controller/project_task_controller.dart';
import 'package:todo_app/widgets/dashboard_header.dart';
import '../todo_page.dart';

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

  @override
  void initState() {
    super.initState();
    _projectController = Get.put(ProjectController());
    Get.put(ProjectTaskController());
  }

  // ── Hardcoded labels and statuses (until you build those features) ─
  final List<LabelItem> labels = const [
    LabelItem(color: Color(0xFF7C7CE0), title: 'Study', count: 5),
    LabelItem(color: Color(0xFF445273), title: 'Sports', count: 2),
    LabelItem(color: Color(0xFFE08A3C), title: 'Work', count: 2),
    LabelItem(color: Color(0xFFE0B23C), title: 'Personal', count: 2),
    LabelItem(color: Color(0xFF3CB17A), title: 'Habit', count: 3),
  ];

  final List<StatusItem> statuses = const [
    StatusItem(color: Color(0xFFE4572E), title: 'To do'),
    StatusItem(color: Color(0xFFE0A93C), title: 'Doing'),
    StatusItem(color: Color(0xFF3CB17A), title: 'Done'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEAEA),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TodoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          DashboardHeader(title: "Dashboard", isDashboard: true, onTap: () {}),
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
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dashboardCard(
                          title: "Reports",
                          icon: Icons.view_kanban,
                          onTap: () {},
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
                    LayoutBuilder(
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
                                    title: label.title,
                                    count: label.count,
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),

                  // ── Status section ──
                  SectionHeader(
                    title: "Status",
                    expanded: statusExpanded,
                    onToggle: () =>
                        setState(() => statusExpanded = !statusExpanded),
                    onAdd: () {},
                  ),
                  if (statusExpanded)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: statuses
                            .map(
                              (status) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: StatusChip(
                                  color: status.color,
                                  title: status.title,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
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
      if (_projectController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF666AF6)),
          ),
        );
      }

      // empty state
      if (_projectController.projects.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'No projects yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap + to create your first project',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
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
        (p)=> p.id == project.id,
        orElse: ()=> project
      );
      final progress = '${fresh.completedTasks}/${fresh.totalTasks}';
      final bool allDone =
          project.totalTasks > 0 &&
          project.completedTasks == project.totalTasks;

      return InkWell(
        onTap: () => Get.to(() => ProjectDetail(project: project)),
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
                  color: project.color,
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
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey,
                      ),
                    ),
                    if (project.totalTasks > 0) ...[
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: project.totalTasks == 0
                            ? 0
                            : project.completedTasks / project.totalTasks,
                        backgroundColor: Colors.grey.shade200,
                        color: allDone
                            ? const Color(0xFF4CAF82)
                            : project.color,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 4,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // ── Progress label ──
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
        ),
      );
    });
  }
}

// ── StatusChip ─────────────────────────────────────────────────────
class StatusChip extends StatelessWidget {
  final Color color;
  final String title;
  const StatusChip({super.key, required this.color, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Labelchip ──────────────────────────────────────────────────────
class Labelchip extends StatelessWidget {
  final String title;
  final Color color;
  final int count;

  const Labelchip({
    super.key,
    required this.color,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => LabelDetail()),
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
            Text(
              '$count',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
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
