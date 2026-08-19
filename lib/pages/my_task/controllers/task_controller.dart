import 'package:get/get.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/pages/my_task/services/task_service.dart';
import 'package:uuid/uuid.dart';

class TaskController extends GetxController {
  final TaskService _service = TaskService();

  // ── Observable state ──────────────────────────────────────────────
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToTasks();
  }

  // ── Real-time stream → RxList ─────────────────────────────────────
  void _listenToTasks() {
    _service.watchTasks().listen(
      (data) => tasks.value = data,
      onError: (e) => errorMessage.value = 'Failed to load tasks.',
    );
  }

  // ── Create ────────────────────────────────────────────────────────
  Future<void> createTask({
    required String title,
    required String description,
    required TaskPriority priority,
    List<String>? labels,
    DateTime? dueDate,
  }) async {
    try {
      errorMessage.value = '';
      final task = Task(
        id: const Uuid().v4(),
        title: title,
        description: description,
        status: TaskStatus.todo, // always starts as todo
        priority: priority,
        labels: labels ?? [],
        dueDate: dueDate,
      );
      await _service.createTask(task);
    } catch (e) {
      errorMessage.value = 'Failed to create task.';
    }
  }

  // ── Update ────────────────────────────────────────────────────────
  Future<void> updateTask(Task task) async {
    try {
      errorMessage.value = '';
      await _service.updateTask(task);
    } catch (e) {
      errorMessage.value = 'Failed to update task.';
    }
  }

  // ── Update status ─────────────────────────────────────────────────
  Future<void> updateStatus(
    String taskId,
    TaskStatus oldStatus,
    TaskStatus newStatus,
  ) async {
    if (oldStatus == newStatus) return;
    try {
      errorMessage.value = '';
      await _service.updateStatus(taskId, newStatus);
    } catch (e) {
      errorMessage.value = 'Failed to update status.';
    }
  }

  // ── Delete ────────────────────────────────────────────────────────
  Future<void> deleteTask(String taskId) async {
    try {
      errorMessage.value = '';
      await _service.deleteTask(taskId);
    } catch (e) {
      errorMessage.value = 'Failed to delete task.';
    }
  }

  Future<void> deleteTasks(Iterable<Task> tasksToDelete) async {
    for (final task in tasksToDelete) {
      await deleteTask(task.id);
    }
  }

  // ── getter to filter task according to status ──────────────────────────────────────────────
  List<Task> get todoTasks =>
      tasks.where((t) => t.status == TaskStatus.todo).toList();

  List<Task> get doingTasks =>
      tasks.where((t) => t.status == TaskStatus.doing).toList();

  List<Task> get doneTasks =>
      tasks.where((t) => t.status == TaskStatus.done).toList();

  List<Task> get activeTasks =>
      tasks.where((task) => task.status != TaskStatus.done).toList();

  List<Task> get visibleTasks => activeTasks;

  // getter to filters acccrodig to due date
  bool _isSameDay(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Task> get todayTasks {
    final now = DateTime.now();
    return visibleTasks.where((task) => _isSameDay(now, task.dueDate)).toList();
  }

  List<Task> get noDueDateTasks =>
      visibleTasks.where((task) => task.dueDate == null).toList();

  List<Task> get tomorrowTasks {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return visibleTasks
        .where((task) => _isSameDay(tomorrow, task.dueDate))
        .toList();
  }

  List<Task> get thisWeekTasks {
    final now = DateTime.now();
    final dayAfterTomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 2));
    final daysUntilSunday = 7 - now.weekday;
    final endOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: daysUntilSunday, hours: 23, minutes: 59));

    return visibleTasks.where((task) {
      if (task.dueDate == null) return false;

      return task.dueDate!.isAfter(
            dayAfterTomorrow.subtract(const Duration(seconds: 1)),
          ) &&
          task.dueDate!.isBefore(endOfWeek.add(const Duration(seconds: 1)));
    }).toList();
  }

  // ── Count getters (for dashboard status chips) ────────────────────
  int get todoCount => todoTasks.length;
  int get doingCount => doingTasks.length;
  int get doneCount => doneTasks.length;

  // ── Single task lookup ────────────────────────────────────────────
  Task? getById(String taskId) {
    try {
      return tasks.firstWhere((t) => t.id == taskId);
    } catch (_) {
      return null;
    }
  }
}
