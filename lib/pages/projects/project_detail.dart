import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/dashboard_header.dart';

class ProjectDetail extends StatelessWidget{
  const ProjectDetail({ super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: DashboardHeader(title: "Project Details", isDashboard: false, onTap: ()=> Get.back()),
    );
  }
}