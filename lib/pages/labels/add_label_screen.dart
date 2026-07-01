import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/page_header.dart';

class AddLabelScreen extends StatelessWidget{
  const AddLabelScreen({ super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageHeader(title: "Add Label", onBack: ()=>Get.back())
    );
  }
}