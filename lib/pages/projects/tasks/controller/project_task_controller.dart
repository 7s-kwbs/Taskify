import 'package:get/get.dart';
import 'package:todo_app/pages/projects/tasks/services/project_task_service.dart';
import 'package:uuid/uuid.dart';

import '../model/project_task_model.dart';

class ProjectTaskController extends GetxController{
  final ProjectTaskService _services = ProjectTaskService();

  //observable state
  final RxList<ProjectTask> tasks = <ProjectTask>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  //set this when navigating to projectDetail screen
  String? _currentProjectId;

  //start listening to tasks for a specific project
  void loadTask(String projectId){
    if(_currentProjectId == projectId) return;
    _currentProjectId = projectId;
    tasks.clear();

    _services.watchTasks(projectId).listen(
      (data)=> tasks.value = data,
      onError: (e)=> errorMessage.value = "Failed to load tasks",
    );
  }

  //create
  Future<bool> createTask({
      required String projectId,
      required String title,
      required String description,
      required ProjectTaskPriority priority,
      required ProjectTaskStatus status,
      List<String>? labels,
      DateTime? dueDate,
  }) async{
    try{
      isLoading.value = true;
      errorMessage.value = "";

      final task = ProjectTask(
        id: const Uuid().v4(), 
        title: title, 
        description: description, 
        status: status, 
        priority: priority, 
        projectId: projectId,
        dueDate:  dueDate,
      );
      await _services.createTask(task);
      return true;
    }catch (e){
      errorMessage.value = "Failed to create task.";
      return false;
    }finally{
      isLoading.value = false;
    }
  }

  //update
  Future<bool> updateTask(ProjectTask task) async{
    try{
      isLoading.value = true;
      errorMessage.value = "";

      await _services.updateTask(task);
      return true;
    } catch (e){
      errorMessage.value = "Failed to update task.";
      return false;
    }finally{
      isLoading.value = false;
    }
  }

  //update status
  Future<void> updateStatus(
    String projectId, 
    String taskId,
    ProjectTaskStatus status,
  )async{
    try{
      errorMessage.value = '';
      await _services.updateStatus(projectId, taskId, status);
    }catch (e){
      errorMessage.value = "Failed to update task Status";
    }
  }

  //delete task
  Future<void> deleteTask(String projectId, String taskId) async{
    try{
      errorMessage.value = "";
      _services.deleteTask(projectId, taskId);
    }catch(e){
      errorMessage.value  = "Failed to delete task";
    }
  }

  // ── Filtered getters ──────────────────────────────────────────────
  List<ProjectTask> get todoTasks =>
      tasks.where((t) => t.status == ProjectTaskStatus.todo).toList();
 
  List<ProjectTask> get doingTasks =>
      tasks.where((t) => t.status == ProjectTaskStatus.doing).toList();
 
  List<ProjectTask> get doneTasks =>
      tasks.where((t) => t.status == ProjectTaskStatus.done).toList();
 
 
  int get totalTasks => tasks.length;
  int get completedTasks => doneTasks.length;
 
  // returns 0.0 → 1.0 for a progress bar
  double get completionRatio =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
 
  // returns "2/5" format for ProjectCard
  String get progressLabel => '$completedTasks/$totalTasks';
}