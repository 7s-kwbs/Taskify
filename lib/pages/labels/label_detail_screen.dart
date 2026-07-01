import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/page_header.dart';

class LabelDetail extends StatelessWidget{
  const LabelDetail({ super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageHeader(title: "Label Detail", onBack: ()=> Get.back())
    );
  }
}