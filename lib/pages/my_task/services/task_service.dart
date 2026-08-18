import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Helpers ───────────────────────────────────────────────────────

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return uid;
  }

  // users/{uid}/tasks/{taskId}
  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection('users').doc(_uid).collection('tasks');

  // ── Firestore → Task ──────────────────────────────────────────────

  Task _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.todo,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      labels: List<String>.from(map['labels'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      dueDate: map['dueDate'] != null
          ? (map['dueDate'] as Timestamp).toDate()
          : null,
    );
  }

  // ── Task → Firestore ──────────────────────────────────────────────

  Map<String, dynamic> _toMap(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'status': task.status.name,
      'priority': task.priority.name,
      'labels': task.labels,
      'createdAt': Timestamp.fromDate(task.createdAt),
      'dueDate':
          task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
    };
  }

  Map<String, dynamic> _toUpdateMap(Task task) {
    return {
      'title': task.title,
      'description': task.description,
      'priority': task.priority.name,
      'labels': task.labels,
      'dueDate':
          task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
    };
  }

  // ── Real-time stream ──────────────────────────────────────────────

  Stream<List<Task>> watchTasks() {
    return _collection
        .orderBy('createdAt', descending: false)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) => snapshot.docs.map(_fromDoc).toList());
  }

  // ── Create ────────────────────────────────────────────────────────

  Future<void> createTask(Task task) async {
    _collection.doc(task.id).set(_toMap(task));
  }

  // ── Update ────────────────────────────────────────────────────────

  Future<void> updateTask(Task task) async {
    _collection.doc(task.id).update(_toUpdateMap(task));
  }

  // ── Update status only ────────────────────────────────────────────

  Future<void> updateStatus(String taskId, TaskStatus status) async {
    _collection.doc(taskId).update({'status': status.name});
  }

  // ── Delete ────────────────────────────────────────────────────────

  Future<void> deleteTask(String taskId) async {
    _collection.doc(taskId).delete();
  }
}