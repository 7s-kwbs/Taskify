
import 'package:flutter/material.dart';

void showDeleteDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delee this task ?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed: (){
            onConfirm();
            Navigator.pop(context);
          }, child: Text("Delete", 
          style: TextStyle(
            color: Colors.red
          ),))
        ],
      );
    }
  );
}