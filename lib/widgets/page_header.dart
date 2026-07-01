import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final Widget? action; 

  const PageHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF666AF6)),
      child: Stack(
        children: [
          // ── Decorative circle (same as DashboardHeader) ──
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

          // ── Optional right action ──
          if (action != null)
            Positioned(
              top: 60,
              right: 24,
              child: action!,
            ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.only(top: 70, left: 24, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ──
                InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(20),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.deepPurple,
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 10,),

                // ── Title ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.8
                      ),
                    ),

                    Text(
                      "Project Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        letterSpacing: 1
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}