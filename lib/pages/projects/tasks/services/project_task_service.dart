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
      projectId: map['projectId'] as String,
      labels: List<String>.from(map['labels'] ?? []),
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
    await _db 
            .collection('users')
            .doc(_uid)
            .collection('projects')
            .doc(task.projectId)
            .update({"totalTasks" : FieldValue.increment(1)});
  }

  //update
  Future<void> updateTask(ProjectTask task) async{
    await _taskCollection(task.projectId).doc(task.id).update(_toMap(task));
  }

  //update status
  Future<void> updateStatus( String projectId, String taskId, ProjectTaskStatus oldstatus, ProjectTaskStatus newStatus) async{
    if(oldstatus == newStatus) return;
    await _taskCollection(projectId)
            .doc(taskId)
            .update({'status' : newStatus.name});
    if(newStatus == ProjectTaskStatus.done){
      await _db
            .collection("users")
            .doc(_uid)
            .collection("projects")
            .doc(projectId)
            .update({"completedTasks": FieldValue.increment(1)});
    }else if(oldstatus == ProjectTaskStatus.done){
      await _db
            .collection("users")
            .doc(_uid)
            .collection("projects")
            .doc(projectId)
            .update({"completedTasks": FieldValue.increment(-1)});
    }
  }

  //delete task
  Future<void> deleteTask(String projectId, String taskId) async{
    final doc = await _taskCollection(projectId).doc(taskId).get();
    final task = _fromDoc(doc);

    await _taskCollection(projectId).doc(taskId).delete();

    final Map<String, dynamic> updates ={
      'totalTasks': FieldValue.increment(-1),
    };

    if(task.status == ProjectTaskStatus.done){
      updates["completedTasks"] = FieldValue.increment(-1);
    }

    await _db
          .collection('users')
          .doc(_uid)
          .collection('projects')
          .doc(projectId)
          .update(updates);
  }
}