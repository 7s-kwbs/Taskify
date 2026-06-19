import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

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
            child: const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white24,
              child: Icon(Icons.settings, color: Colors.white, size: 32,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.deepPurple),
                ),
                const SizedBox(height: 10,),
                Text(
                  "Today, 1 May",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Dashboard",
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
