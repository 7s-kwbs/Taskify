import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/dashboard_header.dart' show DashboardHeader;

class AddLabelScreen extends StatelessWidget{
  const AddLabelScreen({ super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: DashboardHeader(title: "Add Label", isDashboard: false, onTap: ()=> Get.back()),
    );
  }
}