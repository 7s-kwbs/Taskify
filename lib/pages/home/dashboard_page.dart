import 'package:flutter/material.dart';
import 'package:todo_app/models/label_item_model.dart';
import 'package:todo_app/models/project_item_model.dart';
import 'package:todo_app/models/status_item_model.dart';
import 'package:todo_app/widgets/dashboard_header.dart';

import 'todo_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool projectExpanded = true;
  bool labelsExpanded = true;
  bool statusExpanded = true;

  final List<ProjectItem> projects = const [
    ProjectItem(
      iconColor: Color(0xFF7C7CE0),
      title: 'CareerFoundry Course',
      count: 5,
    ),
    ProjectItem(
      iconColor: Color(0xFFE08A3C),
      title: "App Design Project",
      count: 2,
    ),
  ];

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
      backgroundColor: const Color.fromARGB(255, 236, 234, 234),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  TodoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const DashboardHeader(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dashboardCard(title: "List", icon: Icons.list_outlined),
                    _dashboardCard(
                      title: "Calendar",
                      icon: Icons.calendar_month,
                    ),
                    _dashboardCard(title: "Reports", icon: Icons.view_kanban),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    SectionHeader(
                      title: "Projects",
                      expanded: projectExpanded,
                      onToggle: () =>
                          setState(() => projectExpanded = !projectExpanded),
                      onAdd: () {},
                    ),
                    if (projectExpanded)
                      Column(
                        children: projects
                            .map(
                              (p) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 10,
                                ),
                                child: ProjectCard(item: p),
                              ),
                            )
                            .toList(),
                      ),
                    SectionHeader(
                      title: "Labels",
                      expanded: labelsExpanded,
                      onToggle: () =>
                          setState(() => labelsExpanded = !labelsExpanded),
                      onAdd: () {},
                    ),
                    if (labelsExpanded)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // One gap (spacing: 10) sits between the two
                          // columns, so only subtract it once.
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard({required String title, required IconData icon}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 61, 41, 116),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 140,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: const Color(0xFF666AF6), size: 42),
        ),
      ],
    );
  }
}

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
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
          Icon(Icons.local_offer_outlined, color: color, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Text(
            "$count",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final ProjectItem item;
  const ProjectCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(Icons.assignment_sharp, color: item.iconColor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Text(
            "${item.count}",
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

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
            fontSize: 22,
            fontWeight: FontWeight.w500,
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
                  size: 42,
                ),
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: Icon(Icons.add, color: Colors.grey.shade500, size: 32),
            ),
          ],
        ),
      ],
    );
  }
}