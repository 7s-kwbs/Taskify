import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/auth_controller.dart';
import 'package:todo_app/auth/forget_page.dart';
import 'package:todo_app/pages/dashboard/dashboard_page.dart';
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
      backgroundColor: const Color(0xFFF5F5FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 120, left: 50, right: 50),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/image1.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Form(
                autovalidateMode: _autovalidateMode,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Email"),
                    SizedBox(height: 8,),
                    _buildEmailField(),

                    SizedBox( height: 10,),
                    _buildLabel("Password"),
                    SizedBox(height: 8,),
                    _buildPasswordField(),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: ()=> Get.to(()=> ForgetPage()), 
                      child: Text(
                        "Forget Password",
                        style: TextStyle(
                          color: Color(0xFF666AF6),
                          fontWeight: FontWeight.w500,
                        ),
                        )
                      ),
                    ),

                    const SizedBox(height: 8,),
                    _buildLoginButton(),

                    const SizedBox(height: 24,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: ()=> Get.to(()=> SignupPage()),
                          child: const Text(
                            "SignUp",
                            style: TextStyle(
                              color: Color(0xFF666AF6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
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
      decoration: _inputDecoration("Enter Your email"),
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
      decoration:  _inputDecoration("Enter your password").copyWith(
        suffixIcon: IconButton(
          onPressed: () => setState(()=> _obscurePassword = !_obscurePassword), 
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF9E9E9E),
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



