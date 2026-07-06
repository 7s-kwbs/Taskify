import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/projects/models/project_model.dart';
import 'package:todo_app/pages/projects/services/project_services.dart';
import 'package:uuid/uuid.dart';

class ProjectController extends GetxController {
  final ProjectServices _service = ProjectServices();

  final RxList<Project> projects = <Project>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    _listenToProjects();
  }

  void _listenToProjects() {
    _service.watchProjects().listen(
      (data) => projects.value = data,
      onError: (e) => errorMessage.value = " Failed to load Projects.",
    );
  }

  //Create
  Future<bool> createProject({
    required String name,
    required String description,
    required DateTime deadline,
    required ProjectPriority priority,
    required Color color,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final project = Project(
        id: const Uuid().v4(),
        name: name,
        description: description,
        deadline: deadline,
        priority: priority,
        color: color,
      );

       _service.createProject(project);
      return true;
    } catch (e) {
      errorMessage.value = "Failed to create Project.";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //Update
  Future<bool> updateProject(Project project) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      await _service.updateProject(project);
      return true;
    } catch (e) {
      errorMessage.value = "Failed to update Project.";
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  //Update status
  Future<void> updateStatus(String projectId, ProjectStatus status,) async{
    try{
      errorMessage.value = "";
      await _service.updateStatus(projectId, status);
    }catch(e){
      errorMessage.value = "Failed to update status.";
    }
  }


  //Delete
  Future<void> deleteProject(String projectId) async{
    try{
      errorMessage.value = "";
      await _service.deleteProject(projectId);
    }catch(e){
      errorMessage.value = "Failed to delete project.";
    }
  }

  // //add task to project
  // Future<bool> addTaskId(String projectId, String taskId) async {
  //   try{
  //     isLoading.value = true;
  //     errorMessage.value = "";
  //     await _service.addTaskId(projectId, taskId);
  //     return true;
  //   }catch(e){
  //     errorMessage.value = "Failed to addTask";
  //     return false;
  //   }finally{
  //     isLoading.value = false;
  //   }
  // }

  // //delete task
  // Future<void> removeTaskId(String projectId, String taskId) async{
  //   try{
  //   errorMessage.value = "";
  //   await _service.deleteProject(projectId);
  //   }catch(e){
  //     errorMessage.value = "Failed to delete task";
  //   }
  // }


}
