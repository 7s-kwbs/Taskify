import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/labels/controllers/label_controller.dart';
import 'package:todo_app/pages/my_task/controllers/task_controller.dart';
import 'package:todo_app/pages/my_task/models/task_model.dart';
import 'package:todo_app/widgets/page_header.dart';

class AddIndependentTaskScreen extends StatefulWidget {
  final Task? existingTask; // null = create, not null = edit
  const AddIndependentTaskScreen({super.key, this.existingTask});

  @override
  State<AddIndependentTaskScreen> createState() =>
      _AddIndependentTaskScreenState();
}

class _AddIndependentTaskScreenState extends State<AddIndependentTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _dueDateController;

  late DateTime? _dueDate;
  late TaskPriority _priority;
  late List<String> _selectedLabels;

  bool get _isEditing => widget.existingTask != null;

  final TaskController _taskController = Get.find<TaskController>();

  static const Map<TaskPriority, String> _priorityLabel = {
    TaskPriority.low: 'Low',
    TaskPriority.medium: 'Medium',
    TaskPriority.high: 'High',
  };

  static const Map<TaskPriority, Color> _priorityColor = {
    TaskPriority.low: Color(0xFF4CAF82),
    TaskPriority.medium: Color(0xFFFFB347),
    TaskPriority.high: Color(0xFFFF6B6B),
  };

  @override
  void initState() {
    super.initState();
    final t = widget.existingTask;

    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _dueDateController = TextEditingController(
      text: t?.dueDate != null
          ? DateFormat('dd MMM yyyy').format(t!.dueDate!)
          : '',
    );
    _dueDate = t?.dueDate;
    _priority = t?.priority ?? TaskPriority.medium;
    _selectedLabels = List<String>.from(t?.labels ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  // ── Date picker ───────────────────────────────────────────────────
  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF666AF6),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF25343B),
          ),
          datePickerTheme: const DatePickerThemeData(
            headerBackgroundColor: Color(0xFF666AF6),
            headerForegroundColor: Colors.white,
            headerHeadlineStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  // ── Submit ────────────────────────────────────────────────────────
  Future<void> _submit() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;

    if (_isEditing) {
      final updated = widget.existingTask!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _priority,
        labels: _selectedLabels,
        dueDate: _dueDate,
      );
      await _taskController.updateTask(updated);
      Get.back();
      Get.snackbar(
        'Task Updated',
        '${updated.title} has been updated.',
        backgroundColor: const Color(0xFF4CAF82),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      await _taskController.createTask(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _priority,
        labels: _selectedLabels,
        dueDate: _dueDate,
      );
      Get.back();
      Get.snackbar(
        'Task Added',
        '${_titleController.text.trim()} has been added.',
        backgroundColor: const Color(0xFF4CAF82),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          PageHeader(
            title: _isEditing ? 'Edit Task' : 'Add Task',
            onBack: () => Get.back(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title ──
                    _buildLabel('Task Title'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: _inputDecoration('Enter task title'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Task title is required.';
                        }
                        if (v.trim().length < 3) {
                          return 'Title must be at least 3 characters.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── Description ──
                    _buildLabel('Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 15),
                      decoration: _inputDecoration(
                        'Enter task description (optional)',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Due date ──
                    _buildLabel('Due Date (optional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dueDateController,
                      readOnly: true,
                      onTap: _pickDueDate,
                      style: const TextStyle(fontSize: 15),
                      decoration: _inputDecoration('Select due date').copyWith(
                        suffixIcon: _dueDate != null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFF9E9E9E),
                                  size: 18,
                                ),
                                onPressed: () => setState(() {
                                  _dueDate = null;
                                  _dueDateController.clear();
                                }),
                              )
                            : const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF9E9E9E),
                                size: 18,
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Priority ──
                    _buildLabel('Priority'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<TaskPriority>(
                      value: _priority,
                      decoration: _inputDecoration(''),
                      items: TaskPriority.values.map((priority) {
                        return DropdownMenuItem<TaskPriority>(
                          value: priority,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _priorityColor[priority],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _priorityLabel[priority]!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _priority = value);
                      },
                    ),

                    const SizedBox(height: 20),

                    // ── Labels ──
                    _buildLabel('Labels'),
                    const SizedBox(height: 12),
                    _buildLabelPicker(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Button ──
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF666AF6),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF666AF6).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              _isEditing ? 'Update Task' : 'Add Task',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── Label picker ──────────────────────────────────────────────────
  Widget _buildLabelPicker() {
    final labelController = Get.find<LabelController>();

    return Obx(() {
      final labels = labelController.labels.toList();
      if (labels.isEmpty) {
        return const Text(
          'No labels available. Create one from the dashboard.',
          style: TextStyle(color: Colors.blueGrey, fontSize: 13),
        );
      }

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: labels.map((label) {
          final isSelected = _selectedLabels.contains(label.id);

          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedLabels.remove(label.id);
                } else {
                  _selectedLabels.add(label.id);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? label.color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? label.color : const Color(0xFFE0E0E0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: label.color.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: 14,
                    color: isSelected ? Colors.white : label.color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.blueGrey,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.check, size: 14, color: Colors.white),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF9E9E9E),
        letterSpacing: 0.8,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF666AF6), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
      ),
    );
  }
}
