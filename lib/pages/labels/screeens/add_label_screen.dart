import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/labels/controllers/label_controller.dart';
import 'package:todo_app/pages/labels/model/label_model.dart';
import 'package:todo_app/widgets/page_header.dart';

class AddLabelScreen extends StatefulWidget {
  final Label? existingLabel;
  const AddLabelScreen({super.key, this.existingLabel});

  @override
  State<AddLabelScreen> createState() => _AddLabelScreenState();
}

class _AddLabelScreenState extends State<AddLabelScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late final TextEditingController _nameController;
  late Color _selectedColor;

  bool get _isEditing => widget.existingLabel != null;

  final LabelController _labelController = Get.find<LabelController>();

  // ── Color options ─────────────────────────────────────────────────
  static const List<Color> _colorOptions = [
    Color(0xFF666AF6), // purple
    Color(0xFFFF6B6B), // coral red
    Color(0xFFFFB347), // amber
    Color(0xFF4CAF82), // mint green
    Color(0xFF4FC3F7), // sky blue
    Color(0xFFBA68C8), // lavender
    Color(0xFF7C7CE0), // indigo
    Color(0xFF445273), // navy
    Color(0xFFE08A3C), // orange
    Color(0xFFE0B23C), // yellow
    Color(0xFF3CB17A), // green
    Color(0xFFE4572E), // red orange
  ];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingLabel?.name ?? '');
    _selectedColor =
        widget.existingLabel?.color ?? const Color(0xFF666AF6);

    // rebuild preview when name changes
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────
  Future<void> _submit() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;

    if (_isEditing) {
      final updated = widget.existingLabel!.copyWith(
        name: _nameController.text.trim(),
        color: _selectedColor,
      );
      await _labelController.updateLabel(updated);
      Get.back();
      Get.snackbar(
        'Label Updated',
        '${updated.name} has been updated.',
        backgroundColor: const Color(0xFF4CAF82),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      await _labelController.createLabel(
        name: _nameController.text.trim(),
        color: _selectedColor,
      );
      Get.back();
      Get.snackbar(
        'Label Created',
        '${_nameController.text.trim()} has been added.',
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
            title: _isEditing ? 'Edit Label' : 'Add Label',
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
                    // ── Label name ──
                    _buildSectionLabel('Label Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                      decoration: _inputDecoration('e.g. Study, Work, Gym'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Label name is required.';
                        if (v.trim().length < 2)
                          return 'Name must be at least 2 characters.';
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    // ── Color picker ──
                    _buildSectionLabel('Color'),
                    const SizedBox(height: 16),
                    _buildColorPicker(),

                    const SizedBox(height: 28),

                    // ── Preview ──
                    _buildSectionLabel('Preview'),
                    const SizedBox(height: 12),
                    _buildPreviewChip(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Save button ──
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
              _isEditing ? 'Update Label' : 'Create Label',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── Color picker grid ─────────────────────────────────────────────
  Widget _buildColorPicker() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _colorOptions.length,
      itemBuilder: (context, index) {
        final color = _colorOptions[index];
        final isSelected = _selectedColor == color;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
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
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        );
      },
    );
  }

  // ── Live preview chip ─────────────────────────────────────────────
  Widget _buildPreviewChip() {
    final name = _nameController.text.trim().isEmpty
        ? 'Label Name'
        : _nameController.text.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _selectedColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _selectedColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_offer_outlined,
              size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
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
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide:
            const BorderSide(color: Color(0xFF666AF6), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
      ),
    );
  }
}