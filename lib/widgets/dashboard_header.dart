import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/auth/auth_controller.dart';

class DashboardHeader extends StatefulWidget {
  final VoidCallback onSettingsTap;

  const DashboardHeader({
    super.key,
    required this.onSettingsTap,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late final String month;
  late final String day;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    month = DateFormat("MMM").format(now);
    day = DateFormat("d").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF666AF6)),
      child: Stack(
        children: [
          // ── Decorative circle ──
          Positioned(
            left: -40,
            top: 50,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF878AF5),
              ),
            ),
          ),

          // ── Settings button (right) ──
          Positioned(
            top: 60,
            right: 24,
            child: InkWell(
              onTap: widget.onSettingsTap,
              borderRadius: BorderRadius.circular(32),
              child: const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── User avatar with initials ──
                Obx(() {
                  final name = _authController.displayName;
                  final initials = name
                      .trim()
                      .split(' ')
                      .where((e) => e.isNotEmpty)
                      .take(2)
                      .map((e) => e[0].toUpperCase())
                      .join();

                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      initials.isEmpty ? 'U' : initials,
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 10),

                // ── Greeting ──
                Obx(() {
                  final name = _authController.displayName;
                  return Text(
                    'Hi, $name 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 1.2
                    ),
                  );
                }),

                // ── Date ──
                Text(
                  'Today, $day $month',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}