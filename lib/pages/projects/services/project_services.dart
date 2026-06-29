import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/projects/models/project_model.dart';

class ProjectServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
//helpers
  String get _uid{
    final uid = _auth.currentUser?.uid;
    if(uid == null) throw Exception("user not logged in");
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _collection =>
  _db.collection("users").doc(_uid).collection("projects");

//firestore  -> model
  Project _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc){
    final map = doc.data()!;
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      deadline: (map['deadline'] as Timestamp).toDate(),
      priority: ProjectPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => ProjectPriority.medium,
      ),
      color: Color(map['color'] as int),
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ProjectStatus.todo,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      taskIds: List<String>.from(map['taskIds']?? []),
      totalTasks: map['totalTasks'] as int? ?? 0,
      completedTasks: map['completedTasks'] as int? ?? 0,
    );
  }

  //mode -> firestore
  Map<String, dynamic> _toMap(Project project){
    return{
      
      'id': project.id,
      'name': project.name,
      'description': project.description,
      'deadline': Timestamp.fromDate(project.deadline),
      'priority': project.priority.name,
      'color': project.color.value,
      'status': project.status.name,
      'createdAt': Timestamp.fromDate(project.createdAt),
      'taskIds': project.taskIds,
      'totalTasks': project.totalTasks,
      "completedTasks":project.completedTasks,
    };
  }

  Map<String,dynamic> _toUpdateMap(Project project){
    return{
      'name': project.name,
      'description': project.description,
      'deadline': Timestamp.fromDate(project.deadline),
      'priority': project.priority.name,
      'color': project.color.value,
      'status': project.status.name,
    };
  }

  //real time stream
  Stream<List<Project>> watchProjects(){
    return _collection
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(_fromDoc).toList());
  }

  //Create
  Future<void> createProject(Project project) async{
    await _collection.doc(project.id).set(_toMap(project));
  }

  //update
  Future<void> updateProject(Project project) async{
    await _collection.doc(project.id).update(_toUpdateMap(project));
  }

  //update status only
  Future<void> updateStatus(String projectId, ProjectStatus status) async {
    await _collection.doc(projectId).update({'status': status.name});
  }


  //Delete
   Future<void> deleteProject(String projectId) async {
    await _collection.doc(projectId).delete();
  }
}