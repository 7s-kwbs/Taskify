import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/auth_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final AuthController _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //submit
  Future<void> _signup() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    if (!_formKey.currentState!.validate()) return;

    await _authController.signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (_authController.errorMessage.isNotEmpty) {
      _showErrorDialog(_authController.errorMessage.value);
    }
  }

  //Error dialog
  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Color(0xFFFF6B6B)),
            SizedBox(width: 8),
            Text(
              'Sign Up Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          message,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // SizedBox(height: 20),
                // Text(
                //   "Lets get Started",
                //   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                // ),
                // SizedBox(height: 20),
                Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Full Name"),
                      _buildNameField(),

                      SizedBox(height: 10),
                      _buildLabel("Email"),
                      _buildEmailField(),

                      SizedBox(height: 10),
                      _buildLabel("Password"),
                      _buildPasswordField(),

                      SizedBox(height: 10),
                      _buildLabel("Confirm Password"),
                      _buildConfirmPasswordField(),

                      const SizedBox(height: 32),

                      _buildSignupButton(),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFF666AF6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10),
                // Text("OR"),
                // Text(
                //   "Sign in with",
                //   style: TextStyle(fontSize: 16, color: Colors.black),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,

                //   children: [
                //     IconButton(
                //       onPressed: () {},
                //       icon: Icon(
                //         Icons.facebook_rounded,
                //         color: Colors.blue,
                //         size: 32,
                //       ),
                //     ),
                //     // SizedBox(width: 5,),
                //     IconButton(
                //       onPressed: () {},
                //       icon: Image.asset(
                //         "assets/images/google.png",
                //         width: 54,
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //     // SizedBox(width: 5,),
                //     IconButton(
                //       onPressed: () {},
                //       icon: Image.asset(
                //         "assets/images/linkedin.webp",
                //         width: 28,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF666AF6)),
      child: Stack(
        children: [
          Positioned(
            left: -40,
            top: 50,
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF878AF5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_add, color: Colors.deepPurple),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  "Let's get started",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(fontSize: 15),
      decoration: _inputDecoration("Enter your full name"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Name is required.';
        if (value.trim().length < 2)
          return 'Name must be at least 2 characters.';
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 15),
      decoration: _inputDecoration("Enter your email"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Email is required.';
        if (!GetUtils.isEmail(value.trim())) return 'Enter a valid email.';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontSize: 15),
      decoration: _inputDecoration("Enter your password").copyWith(
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Password is required.';
        if (v.trim().length < 6)
          return 'Password must be at least 6 characters.';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      style: const TextStyle(fontSize: 15),
      decoration: _inputDecoration("Re-enter your password").copyWith(
        suffixIcon: IconButton(
          onPressed: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty)
          return 'Please confirm your password.';
        if (v.trim() != _passwordController.text.trim()) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
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

  Widget _buildSignupButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _authController.isLoading.value ? null : _signup,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF666AF6),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF666AF6).withOpacity(0.6),
            elevation: 4,
            shadowColor: const Color(0xFF666AF6).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _authController.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}
