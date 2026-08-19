import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/calendar/controllers/calendar_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/widgets/page_header.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarController = Get.put(CalendarController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          PageHeader(title: 'Calendar', onBack: () => Get.back()),
          Expanded(
            child: Obx(() {
              final selectedTasks = calendarController.selectedDateTasks;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  _buildMonthHeader(calendarController),
                  const SizedBox(height: 16),
                  _buildCalendarGrid(calendarController),
                  const SizedBox(height: 24),
                  Text(
                    DateFormat(
                      'EEEE, d MMMM',
                    ).format(calendarController.selectedDate.value),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (selectedTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Center(
                        child: Text(
                          'No independent tasks for this day.',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  else
                    ...selectedTasks.map(_buildTaskCard),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(CalendarController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: controller.showPreviousMonth,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous month',
        ),
        Text(
          DateFormat('MMMM yyyy').format(controller.visibleMonth.value),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
        IconButton(
          onPressed: controller.showNextMonth,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next month',
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(CalendarController controller) {
    final visibleMonth = controller.visibleMonth.value;
    final firstDayOffset =
        DateTime(visibleMonth.year, visibleMonth.month, 1).weekday - 1;
    final daysInMonth = DateUtils.getDaysInMonth(
      visibleMonth.year,
      visibleMonth.month,
    );
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: dayNames
                .map(
                  (dayName) => Expanded(
                    child: Center(
                      child: Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 48,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - firstDayOffset + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                visibleMonth.year,
                visibleMonth.month,
                dayNumber,
              );
              final isSelected = _isSameDay(
                date,
                controller.selectedDate.value,
              );
              final isToday = _isSameDay(date, DateTime.now());
              final hasTasks = controller.hasTasksOn(date);

              return GestureDetector(
                onTap: () => controller.selectDate(date),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF666AF6) : null,
                    borderRadius: BorderRadius.circular(10),
                    border: isToday && !isSelected
                        ? Border.all(color: const Color(0xFF666AF6))
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (hasTasks)
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFE4572E),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: _statusColor(task.status),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF25343B),
              ),
            ),
          ),
          Text(
            task.status.name,
            style: TextStyle(fontSize: 12, color: _statusColor(task.status)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return const Color(0xFFE4572E);
      case TaskStatus.doing:
        return const Color(0xFFFFB347);
      case TaskStatus.done:
        return const Color(0xFF4CAF82);
    }
  }

  bool _isSameDay(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }
}
