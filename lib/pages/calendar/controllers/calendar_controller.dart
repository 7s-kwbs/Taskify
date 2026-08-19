import 'package:get/get.dart';
import 'package:todo_app/pages/my_task/controllers/task_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';

class CalendarController extends GetxController {
  final TaskController taskController = Get.find<TaskController>();
  final Rx<DateTime> visibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  ).obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  List<Task> get tasksWithDueDate =>
      taskController.tasks.where((task) => task.dueDate != null).toList();

  List<Task> get selectedDateTasks => tasksWithDueDate
      .where((task) => _isSameDay(task.dueDate!, selectedDate.value))
      .toList();

  bool hasTasksOn(DateTime date) =>
      tasksWithDueDate.any((task) => _isSameDay(task.dueDate!, date));

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void showPreviousMonth() {
    final month = visibleMonth.value;
    visibleMonth.value = DateTime(month.year, month.month - 1);
  }

  void showNextMonth() {
    final month = visibleMonth.value;
    visibleMonth.value = DateTime(month.year, month.month + 1);
  }

  bool _isSameDay(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }
}
