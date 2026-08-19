import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/auth_controller.dart';
import 'package:todo_app/auth/forget_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _emailcontroller = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final AuthController _authController = Get.find<AuthController>();

  void dipose() {
    _emailcontroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future <void> _login() async {
    setState(()=> _autovalidateMode = AutovalidateMode.onUserInteraction);
    if(!_formKey.currentState!.validate()) return;
    await _authController.login(
      email: _emailcontroller.text, 
      password: _passwordController.text,
    );


    if (_authController.errorMessage.isNotEmpty) {
      _showErrorDialog(_authController.errorMessage.value);
    }

  }

  Future<dynamic> _showErrorDialog(String message) {
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
        ),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Color(0xFFFF6B6B),),
            SizedBox(width: 8,),
            Text(
              "Login Failed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.blueGrey,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: ()=> Get.back(), 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF666AF6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            child: const Text("Try Again"),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 350,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/images/image1.png', fit: BoxFit.cover),
                    Container(color: Colors.white.withOpacity(0.12)),
                    Positioned(
                      top: 38,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6550D9),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6550D9).withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.task_alt_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Taskify',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF20243A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Organize your tasks. Boost your productivity.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8588A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    autovalidateMode: _autovalidateMode,
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF20243A),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Login to continue to your account',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8E91A8),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildEmailField(),
                        const SizedBox(height: 14),
                        _buildPasswordField(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.to(() => ForgetPage()),
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildLoginButton(),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade200)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(color: Color(0xFF9A9DB2)),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade200)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          title: 'Continue with Google',
                        ),
                        const SizedBox(height: 10),
                        _buildSocialButton(
                          icon: Icons.apple,
                          title: 'Continue with Apple',
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Color(0xFF8E91A8)),
                              ),
                              GestureDetector(
                                onTap: () => Get.to(() => SignupPage()),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    color: Color(0xFF5944D6),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required String title}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: const Color(0xFF34384D), size: 25),
        label: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF34384D),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE2E4EE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  //Label
  Widget _buildLabel( String text) {
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

  //Email field
  Widget _buildEmailField(){
    return TextFormField(
      controller: _emailcontroller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 15),
      decoration: _inputDecoration('Email address').copyWith(
        prefixIcon: const Icon(
          Icons.mail_outline_rounded,
          color: Color(0xFF8E91A8),
        ),
      ),
      validator: (value){
        if(value == null || value.trim().isEmpty) return "Email is required.";
        if(!GetUtils.isEmail(value.trim())) return "Enter a valid email.";
        return null;
      },
    );
  }

  Widget _buildPasswordField(){
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(fontSize: 15),
      decoration: _inputDecoration('Password').copyWith(
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: Color(0xFF8E91A8),
        ),
        suffixIcon: IconButton(
          onPressed: () => setState(()=> _obscurePassword = !_obscurePassword), 
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF8E91A8),
          ),
        ),
      ),
      validator: (value){
        if(value == null || value.trim().isEmpty) return "Password is required.";
         if (value.trim().length < 6) return 'Password must be at least 6 characters.';
        return null;
      },
    );
  }
  Widget _buildLoginButton() {
    return Obx(
      ()=> SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _authController.isLoading.value? null : _login,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF666AF6),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFF666AF6).withOpacity(0.6),
              elevation: 4,
              shadowColor:  const Color(0xFF666AF6).withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)
              )
          ), 
          child: _authController.isLoading.value?
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            ): const Text(
              "Login", 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
        ),
      )
    );
  }

  InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9A9DB2), fontSize: 15),
      filled: true,
      fillColor: const Color(0xFFFCFCFF),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E4EE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E4EE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6550D9), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
      ),
  );
}

}



