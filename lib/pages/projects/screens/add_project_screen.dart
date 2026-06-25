import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:todo_app/pages/projects/models/project_model.dart';
import 'package:todo_app/widgets/dashboard_header.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _deadlinecontroller = TextEditingController();

  DateTime? _deadLine;
  ProjectPriority _priority = ProjectPriority.medium;
  Color _selectedColor = const Color(0xFF666AF6);

  //Color options
  static const List<Color> _colorOptions = [
    Color(0xFF666AF6), // purple (brand)
    Color(0xFFFF6B6B), // coral red
    Color(0xFFFFB347), // amber
    Color(0xFF4CAF82), // mint green
    Color(0xFF4FC3F7), // sky blue
    Color(0xFFBA68C8), // lavender
  ];

  //priority Labels
  static const Map<ProjectPriority, String> _priorityLabel = {
    ProjectPriority.low: "Low",
    ProjectPriority.medium: "Medium",
    ProjectPriority.high: "High",
  };

  //Priority Color
  static const Map<ProjectPriority, Color> _priorityColor = {
    ProjectPriority.low: Color(0xFF4CAF82),
    ProjectPriority.medium: Color(0xFFFFB347),
    ProjectPriority.high: Color(0xFFFF6B6B),
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _deadlinecontroller.dispose();
    super.dispose();
  }

  //Date Picker
  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _deadLine = picked;
        _deadlinecontroller.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  //submit
  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });
    if (!_formKey.currentState!.validate()) return;
    final project = Project(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      deadline: _deadLine!,
      priority: _priority,
      color: _selectedColor,
    );
    print(project.id);
    print(project.name);
    print(project.description);
    print(project.deadline);
    print(project.priority);
    print(project.color);
    print(project.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //header
          DashboardHeader(
            title: "Add New Project",
            isDashboard: false,
            onTap: () => Get.back(),
          ),

          //form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Project Details",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 20,
                      //   ),
                      // ),
                      const SizedBox(height: 12),
                      _buildLabel("Project Name"),
                      // const SizedBox(height: 8,),
                      _nameTextField(),

                      const SizedBox(height: 12),
                      _buildLabel("Description"),
                      _descTextField(),

                      const SizedBox(height: 12),
                      _buildLabel("Deadline"),
                      _deadLineInputField(),

                      const SizedBox(height: 12),
                      _buildLabel("Priority"),
                      _dropDownInputField(),

                      const SizedBox(height: 12),
                      _buildLabel("Color Tag"),
                      const SizedBox(height: 10),
                      _buildColorPicker(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      //create button
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
              shadowColor: const Color(0xFF666AF6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text("Create Project"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildColorPicker() {
    return Row(
      children: _colorOptions.map((color) {
        final isSelected = _selectedColor == color;
        return Padding(
          padding: const EdgeInsets.only(right: 14),
          child: GestureDetector(
            onTap: () => setState(() => _selectedColor = color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _dropDownInputField() {
    return DropdownButtonFormField<ProjectPriority>(
      value: _priority,
      decoration: _inputDecoration(""),
      items: ProjectPriority.values.map((priority) {
        return DropdownMenuItem<ProjectPriority>(
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _priority = value;
          });
        }
      },
    );
  }

  Widget _deadLineInputField() {
    return TextFormField(
      controller: _deadlinecontroller,
      readOnly: true,
      onTap: _pickDeadline,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.calendar_today),
        hintText: "select deadline",
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
      ),
      validator: (value) {
        if (_deadLine == null) {
          return "please Select a deadline";
        }
        return null;
      },
    );
  }

  Widget _descTextField() {
    return TextFormField(
      controller: _descController,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 16),
      decoration: _inputDecoration("Enter the Description of Project"),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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

  Widget _nameTextField() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: _inputDecoration("Enter project name"),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Project name is required.';
        if (v.trim().length < 3) return 'Name must be at least 3 characters.';
        return null;
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF9E9E9E),
        letterSpacing: 0.8,
      ),
    );
  }
}
