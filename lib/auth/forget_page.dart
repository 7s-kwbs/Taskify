import 'package:flutter/material.dart';

class ForgetPage extends StatefulWidget{
  @override
  State<ForgetPage> createState() => _forgetPageState();
}
class _forgetPageState extends State<ForgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

      ),
      body: Column(

      ),

    );
  }

}
