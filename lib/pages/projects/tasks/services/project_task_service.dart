import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/project_task_model.dart';

class ProjectTaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //helper
  String get _uid {
    final uid = _auth.currentUser?.uid;
    if(uid ==  null ) throw Exception("user not logged in");
    return uid;
  }

  CollectionReference<Map<String, dynamic>> _taskCollection( String projectId){
    return _db
    .collection("users")
    .doc(_uid)
    .collection("projects")
    .doc(projectId)
    .collection("tasks");
  }

  ProjectTask _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc){
    final map = doc.data()!;
    return ProjectTask(
      id: map['id'] as String, 
      title: map['title'] as String, 
      description: map['description'] as String? ?? '', 
      status: ProjectTaskStatus.values.firstWhere(
        (e)=>e.name == map['status'],
        orElse: () => ProjectTaskStatus.todo,
      ), 
      priority: ProjectTaskPriority.values.firstWhere(
        (e)=> e.name == map['priority'],
        orElse: ()=> ProjectTaskPriority.medium,
      ), 
      projectId: map['porjectId'] as String,
      labels: List<String>.from(map['labes'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      dueDate: map['dueDate'] != null 
              ? (map['dueDate'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> _toMap(ProjectTask task){
    return{
      "id": task.id,
      "title": task.title,
      "description": task.description,
      "status": task.status.name,
      "priority": task.priority.name,
      "projectId": task.projectId,
      "labels": task.labels,
      "createdAt": Timestamp.fromDate(task.createdAt),
      "dueDate" : task.dueDate != null ? Timestamp.fromDate(task.dueDate!): null,

    };
  }

  //stream for all tasks in a project
  Stream<List<ProjectTask>> watchTasks(String projectId){
    return _taskCollection(projectId)
            .orderBy("createdAt",descending: false)
            .snapshots()
            .map((snapshot)=> snapshot.docs.map(_fromDoc).toList());
  }

  //create 
  Future<void> createTask(ProjectTask task) async{
    await _taskCollection(task.projectId).doc(task.id).set(_toMap(task));
  }

  //update
  Future<void> updateTask(ProjectTask task) async{
    await _taskCollection(task.projectId).doc(task.id).update(_toMap(task));
  }

  //update status
  Future<void> updateStatus( String projectId, String taskId, ProjectTaskStatus status) async{
    await _taskCollection(projectId).doc(taskId).update({"status":status.name});
  }

  //delete task
  Future<void> deleteTask(String projectId, String taskId) async{
    await _taskCollection(projectId).doc(taskId).delete();
  }
}