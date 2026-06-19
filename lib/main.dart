import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/auth/login_page.dart';
import 'package:todo_app/pages/home/dashboard_page.dart';
// import 'package:todo_app/pages/home/todo_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
Future<bool> checkLogin() async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isLoggedIn") ?? false;
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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