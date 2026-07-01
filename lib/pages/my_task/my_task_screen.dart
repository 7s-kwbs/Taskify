import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/my_task/task_model.dart';
import 'package:todo_app/pages/my_task/task_sample_data.dart';
import 'package:todo_app/widgets/bottom_nav.dart';
import 'package:todo_app/widgets/dashboard_header.dart';
import 'package:todo_app/widgets/page_header.dart';

class MytaskScreen extends StatelessWidget {
  const MytaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 234, 234),
      body: Column(
        children: [
          PageHeader(title: "My Tasks", onBack: ()=> Get.back()),
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
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    children: [
                      _SectionHeader(title: "Today"),
                      SizedBox(height: 5),
                      ...todayTasks.map(
                        (task) => _TaskCard(
                          title: task.title,
                          date: task.date,
                          label: task.labels,
                        ),
                      ),
                      SizedBox(height: 12),
                      _SectionHeader(title: "Tommorow"),
                      SizedBox(height: 5),
                      ...tomorrowTasks.map(
                        (task) => _TaskCard(
                          title: task.title,
                          date: task.date,
                          label: task.labels,
                        ),
                      ),
                      SizedBox(height: 12),
                      _SectionHeader(title: "This week"),
                      SizedBox(height: 5),
                      ...thisWeekTasks.map(
                        (task) => _TaskCard(
                          title: task.title,
                          date: task.date,
                          label: task.labels,
                        ),
                      ),
                    ],
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
                              Colors.white.withOpacity(0.8)
                            ],
                            stops: const[0.0,0.4,1]
                          )
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          BottomNav(),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String date;
  final List<TaskLabel> label;
  const _TaskCard({
    required this.title,
    required this.date,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(), 
        extentRatio: 0.15,
        children: [
          Builder(
            builder:(context){
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){print("button cliked");},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.delete, color: Colors.red,),
                ),
              );
            }
          )
        ]),
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
            _CircleCheckbox(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 37, 52, 59),
                      height: 1,
                    ),
                  ),
                  Text(
                    date,
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
            Row(
              children: label
                  .map(
                    (label) => _LabelChip(text: label.text, color: label.color),
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
  final Color color;
  const _LabelChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
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

class _CircleCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepPurpleAccent, width: 4),
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
