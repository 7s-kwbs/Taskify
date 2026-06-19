import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------
/// DATA MODELS
/// ---------------------------------------------------------------------

class ProjectItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int count;

  const ProjectItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.count,
  });
}

class LabelItem {
  final Color color;
  final String title;
  final int count;

  const LabelItem({
    required this.color,
    required this.title,
    required this.count,
  });
}

class StatusItem {
  final Color color;
  final String title;

  const StatusItem({required this.color, required this.title});
}

/// ---------------------------------------------------------------------
/// MAIN DASHBOARD SCREEN
/// ---------------------------------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool projectsExpanded = true;
  bool labelsExpanded = true;
  bool statusExpanded = true;

  final List<ProjectItem> projects = const [
    ProjectItem(
      icon: Icons.bookmark,
      iconColor: Color(0xFF7C7CE0),
      title: 'CareerFoundry Course',
      count: 5,
    ),
    ProjectItem(
      icon: Icons.bookmark,
      iconColor: Color(0xFFE08A3C),
      title: 'App Design Project',
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
      backgroundColor: const Color(0xFFF4F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F6),
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF1F2A44),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------------- PROJECTS ----------------
          SectionHeader(
            title: 'Projects',
            expanded: projectsExpanded,
            onToggle: () => setState(() => projectsExpanded = !projectsExpanded),
            onAdd: () {
              // TODO: handle add project
            },
          ),
          const SizedBox(height: 12),
          if (projectsExpanded)
            Column(
              children: projects
                  .map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ProjectCard(item: p),
                      ))
                  .toList(),
            ),

          const SizedBox(height: 20),

          // ---------------- LABELS ----------------
          SectionHeader(
            title: 'Labels',
            expanded: labelsExpanded,
            onToggle: () => setState(() => labelsExpanded = !labelsExpanded),
            onAdd: () {
              // TODO: handle add label
            },
          ),
          const SizedBox(height: 12),
          if (labelsExpanded)
            LayoutBuilder(
              builder: (context, constraints) {
                // 2 columns with 10px gap between them
                final chipWidth = (constraints.maxWidth - 10) / 2;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: labels
                      .map((l) => SizedBox(
                            width: chipWidth,
                            child: LabelChip(item: l),
                          ))
                      .toList(),
                );
              },
            ),

          const SizedBox(height: 20),

          // ---------------- STATUS ----------------
          SectionHeader(
            title: 'Status',
            expanded: statusExpanded,
            onToggle: () => setState(() => statusExpanded = !statusExpanded),
            onAdd: () {
              // TODO: handle add status
            },
          ),
          const SizedBox(height: 12),
          if (statusExpanded)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: statuses
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: StatusChip(item: s),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// SECTION HEADER  (title + chevron + add button)
/// ---------------------------------------------------------------------

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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2A44),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.add, color: Colors.grey.shade500, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------
/// PROJECT CARD  (full width row card)
/// ---------------------------------------------------------------------

class ProjectCard extends StatelessWidget {
  final ProjectItem item;

  const ProjectCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          Icon(item.icon, color: item.iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2A44),
              ),
            ),
          ),
          Text(
            '${item.count}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// LABEL CHIP  (used in the 2-column grid)
/// ---------------------------------------------------------------------

class LabelChip extends StatelessWidget {
  final LabelItem item;

  const LabelChip({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
          Icon(Icons.local_offer_outlined, color: item.color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2A44),
              ),
            ),
          ),
          Text(
            '${item.count}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// STATUS CHIP  (pill with colored dot)
/// ---------------------------------------------------------------------

class StatusChip extends StatelessWidget {
  final StatusItem item;

  const StatusChip({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2A44),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// DEMO ENTRY POINT (remove if dropping into an existing app)
/// ---------------------------------------------------------------------

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}