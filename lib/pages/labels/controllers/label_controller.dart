import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/pages/labels/model/label_model.dart';
import 'package:todo_app/pages/labels/services/label_services.dart';
import 'package:uuid/uuid.dart';

class LabelController extends GetxController {
  final LabelService _service = LabelService();

  static final List<Label> _defaultLabels = [
    Label(
      id: 'default_work',
      name: 'Work',
      color: Color(0xFF666AF6),
      createdAt: DateTime(2026, 1, 1),
    ),
    Label(
      id: 'default_personal',
      name: 'Personal',
      color: Color(0xFF4CAF82),
      createdAt: DateTime(2026, 1, 2),
    ),
    Label(
      id: 'default_urgent',
      name: 'Urgent',
      color: Color(0xFFE4572E),
      createdAt: DateTime(2026, 1, 3),
    ),
  ];

  // ── Observable state ──────────────────────────────────────────────
  final RxList<Label> labels = <Label>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToLabels();
  }

  // ── Real-time stream → RxList ─────────────────────────────────────
  void _listenToLabels() {
    _service.watchLabels().listen(
      (data) => labels.value = data,
      onError: (e) => errorMessage.value = 'Failed to load labels.',
    );
    _seedDefaultLabels();
  }

  Future<void> _seedDefaultLabels() async {
    try {
      await _service.seedDefaultLabels(_defaultLabels);
    } catch (e) {
      errorMessage.value = 'Failed to load default labels.';
    }
  }

  // ── Create ────────────────────────────────────────────────────────
  Future<void> createLabel({
    required String name,
    required Color color,
  }) async {
    try {
      errorMessage.value = '';
      final label = Label(
        id: const Uuid().v4(),
        name: name.trim(),
        color: color,
        createdAt: DateTime.now(),
      );
      await _service.createLabel(label);
    } catch (e) {
      errorMessage.value = 'Failed to create label.';
    }
  }

  // ── Update ────────────────────────────────────────────────────────
  Future<void> updateLabel(Label label) async {
    try {
      errorMessage.value = '';
      await _service.updateLabel(label);
    } catch (e) {
      errorMessage.value = 'Failed to update label.';
    }
  }

  // ── Delete ────────────────────────────────────────────────────────
  Future<void> deleteLabel(String labelId) async {
    try {
      errorMessage.value = '';
      await _service.deleteLabel(labelId);
    } catch (e) {
      errorMessage.value = 'Failed to delete label.';
    }
  }

  // ── Lookup helpers ────────────────────────────────────────────────

  // get label by id — used when displaying labels on task cards
  Label? getById(String labelId) {
    try {
      return labels.firstWhere((l) => l.id == labelId);
    } catch (_) {
      return null;
    }
  }

  // get label name by id — returns id as fallback if label deleted
  String getNameById(String labelId) {
    return getById(labelId)?.name ?? labelId;
  }

  // get label color by id — returns grey as fallback if label deleted
  Color getColorById(String labelId) {
    return getById(labelId)?.color ?? const Color(0xFF9E9E9E);
  }
}