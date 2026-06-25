import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/dashboard_header.dart' show DashboardHeader;

class LabelDetail extends StatelessWidget{
  const LabelDetail({ super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: DashboardHeader(title: "Label Details", isDashboard: false, onTap: ()=> Get.back()),
    );
  }
}