import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/my_task/screens/add_independent_task_screen.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: ()=>Get.to(()=>AddIndependentTaskScreen()),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x557B6EF6),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    )
                  ]
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavIcon(
                  icon: Icons.format_list_bulleted_rounded,
                  isActive: true,
                  onTap: () {},
                ),
                _NavIcon(
                  icon: Icons.calendar_today_outlined,
                  isActive: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 32,
        color: isActive ? Colors.deepPurple : Colors.grey,
      ),
    );
  }
}
