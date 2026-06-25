import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/auth/login_page.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/pages/dashboard/dashboard_page.dart';
// import 'package:todo_app/pages/home/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

Future<bool> checkLogin() async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggedIn") ?? false;
}
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FutureBuilder(future: checkLogin(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
        if(snapshot.data == true){
          return DashboardPage();
        }else{
          return LoginPage();
        }
      })
    );
  }
}