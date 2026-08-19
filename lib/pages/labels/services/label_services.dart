import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/labels/model/label_model.dart';

class LabelService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Helpers ───────────────────────────────────────────────────────

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    return uid;
  }

  // users/{uid}/labels/{labelId}
  CollectionReference<Map<String, dynamic>> get _collection =>
      _db.collection('users').doc(_uid).collection('labels');

  // ── Firestore → Label ─────────────────────────────────────────────

  Label _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    return Label(
      id: map['id'] as String,
      name: map['name'] as String,
      color: Color(map['color'] as int),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // ── Label → Firestore ─────────────────────────────────────────────

  Map<String, dynamic> _toMap(Label label) {
    return {
      'id': label.id,
      'name': label.name,
      'color': label.color.value,
      'createdAt': Timestamp.fromDate(label.createdAt),
    };
  }

  Map<String, dynamic> _toUpdateMap(Label label) {
    return {
      'name': label.name,
      'color': label.color.value,
    };
  }

  // ── Real-time stream ──────────────────────────────────────────────

  Stream<List<Label>> watchLabels() {
    return _collection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(_fromDoc).toList());
  }

  // ── Create ────────────────────────────────────────────────────────

  Future<void> createLabel(Label label) async {
    await _collection.doc(label.id).set(_toMap(label));
  }

  Future<void> seedDefaultLabels(List<Label> labels) async {
    final userRef = _db.collection('users').doc(_uid);
    final userSnapshot = await userRef.get();
    if (userSnapshot.data()?['defaultLabelsCreated'] == true) return;

    final batch = _db.batch();
    for (final label in labels) {
      batch.set(_collection.doc(label.id), _toMap(label));
    }
    batch.set(
      userRef,
      {'defaultLabelsCreated': true},
      SetOptions(merge: true),
    );
    await batch.commit();
  }

  // ── Update ────────────────────────────────────────────────────────

  Future<void> updateLabel(Label label) async {
    await _collection.doc(label.id).update(_toUpdateMap(label));
  }

  // ── Delete ────────────────────────────────────────────────────────

  Future<void> deleteLabel(String labelId) async {
    await _collection.doc(labelId).delete();
  }
}