import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/auth_controller.dart';
import 'package:todo_app/auth/login_page.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/pages/dashboard/dashboard_page.dart';
// import 'package:todo_app/pages/home/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authController = Get.put(AuthController());
  runApp(MyApp(authController: authController));
}

class MyApp extends StatelessWidget {
  final AuthController authController;
  const MyApp({super.key, required  this.authController});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Obx(()=>authController.currentUser.value == null? LoginPage(): DashboardPage()),
    );
  }
}
