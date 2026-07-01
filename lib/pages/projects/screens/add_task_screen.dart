import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/pages/projects/models/project_model.dart';
import 'package:todo_app/pages/projects/tasks/controller/project_task_controller.dart';
import 'package:todo_app/pages/projects/tasks/model/project_task_model.dart';
import 'package:todo_app/widgets/dashboard_header.dart';
import 'package:todo_app/widgets/page_header.dart';

class AddTaskScreen extends StatefulWidget {
  final Project project;
  const AddTaskScreen({super.key, required this.project});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dueDateController = TextEditingController();

  DateTime? _dueDate;
  ProjectTaskPriority _priority = ProjectTaskPriority.medium;
  final List<String> _selectedLabels = [];

  final ProjectTaskController _taskController =
      Get.find<ProjectTaskController>();

  // ── Default labels — replace with Firestore fetch when Labels feature is built ──
  static const List<Map<String, dynamic>> _defaultLabels = [
    {'name': 'Study', 'color': Color(0xFF7C7CE0)},
    {'name': 'Work', 'color': Color(0xFFE08A3C)},
    {'name': 'Sports', 'color': Color(0xFF445273)},
    {'name': 'Personal', 'color': Color(0xFFE0B23C)},
    {'name': 'Habit', 'color': Color(0xFF3CB17A)},
  ];

  static const Map<ProjectTaskPriority, String> _priorityLabel = {
    ProjectTaskPriority.low: 'Low',
    ProjectTaskPriority.medium: 'Medium',
    ProjectTaskPriority.high: 'High',
  };

  static const Map<ProjectTaskPriority, Color> _priorityColor = {
    ProjectTaskPriority.low: Color(0xFF4CAF82),
    ProjectTaskPriority.medium: Color(0xFFFFB347),
    ProjectTaskPriority.high: Color(0xFFFF6B6B),
  };

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
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF666AF6),
            onPrimary: Colors.white,
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

    final success = await _taskController.createTask(
      projectId: widget.project.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      labels: _selectedLabels,
      dueDate: _dueDate,
    );

    if (success) {
      Get.back();
      Get.snackbar(
        'Task Added',
        '${_titleController.text.trim()} has been added.',
        backgroundColor: const Color(0xFF4CAF82),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      
    } else {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Color(0xFFFF6B6B)),
              SizedBox(width: 8),
              Text(
                'Failed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Text(
            _taskController.errorMessage.value,
            style: const TextStyle(fontSize: 15, color: Colors.blueGrey),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF666AF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Obx(
        () => Stack(
          children: [
            Column(
              children: [
                PageHeader(title: "Add Task", onBack: () => Get.back()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Project indicator ──
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: widget.project.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: widget.project.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.project.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: widget.project.color,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

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
                              if (v == null || v.trim().isEmpty)
                                return 'Task title is required.';
                              if (v.trim().length < 3)
                                return 'Title must be at least 3 characters.';
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
                            decoration: _inputDecoration('Select due date')
                                .copyWith(
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
                          DropdownButtonFormField<ProjectTaskPriority>(
                            value: _priority,
                            decoration: _inputDecoration(''),
                            items: ProjectTaskPriority.values.map((priority) {
                              return DropdownMenuItem<ProjectTaskPriority>(
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
                              if (value != null)
                                setState(() => _priority = value);
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
            if(_taskController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                               color: Color(0xFF666AF6),
                            ),
                            SizedBox( height: 16,),
                            Text(
                              "Adding task...",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            )
                          ],
                        ),
                      ),
                  ),
                ),
              )
          ],
        ),
      ),

      // ── Add task button ──
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _taskController.isLoading.value ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF666AF6),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(
                  0xFF666AF6,
                ).withOpacity(0.6),
                elevation: 4,
                shadowColor: const Color(0xFF666AF6).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _taskController.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── Label picker ──────────────────────────────────────────────────
  Widget _buildLabelPicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _defaultLabels.map((label) {
        final name = label['name'] as String;
        final color = label['color'] as Color;
        final isSelected = _selectedLabels.contains(name);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedLabels.remove(name);
              } else {
                _selectedLabels.add(name);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : const Color(0xFFE0E0E0),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.3),
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
                  color: isSelected ? Colors.white : color,
                ),
                const SizedBox(width: 6),
                Text(
                  name,
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
  }

  // ── Section label ─────────────────────────────────────────────────
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

  // ── Input decoration ──────────────────────────────────────────────
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
