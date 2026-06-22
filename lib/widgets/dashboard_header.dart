import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardHeader extends StatefulWidget {  
  final String title;
  final bool isDashboard;
  const DashboardHeader({super.key, required this.title, required this.isDashboard});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late DateTime now;
  late final String month =DateFormat("MMM").format(now);
  late final String day = DateFormat("d").format(now);

  @override
  void initState(){
    super.initState();

    now = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF666AF6)),
      child: Stack(
        children: [
          //decorative circle
          Positioned(
            left: -40,
            top: 50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF878AF5),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 24,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white24,
              child: Icon( widget.isDashboard? Icons.settings: Icons.menu
              , color: Colors.white, size: 32,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon( widget.isDashboard? Icons.person : Icons.grid_view, color: Colors.deepPurple),
                ),
                const SizedBox(height: 10,),
                Text(
                  "Today, $day $month",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
