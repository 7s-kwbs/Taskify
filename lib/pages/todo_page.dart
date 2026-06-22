import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/auth/login_page.dart';
import 'completed_page/completed_page.dart';
import '../models/todo_model.dart';
import 'package:todo_app/widgets/delete_dialog.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todos = [];
  List<Todo> completedTodos = [];
  final textController = TextEditingController();

  @override
    void initState(){
      super.initState();
      loadTodos();
    }
    

  void saveTodos() async{
    final prefs = await SharedPreferences.getInstance();
    // Save active todos
    List <String> todoList = todos.map((todo)=> jsonEncode(todo.toJson())).toList();
    await prefs.setStringList("todos", todoList );

    //Save completed todos
    List<String> completedList = completedTodos.map((todo)=> jsonEncode(todo.toJson())).toList();
    await prefs.setStringList ("completed_todos", completedList);
    print("saved tools");
  }
  void loadTodos() async{
    final prefs = await SharedPreferences.getInstance();

    List<String>? data = prefs.getStringList("todos");
    List<String>? completedData = prefs.getStringList("completed_todos");

    setState(() {
      if(data != null){
        todos = data.map((item)=> Todo.fromJson(jsonDecode(item))).toList();
        }
        if(completedData != null){
          completedTodos = completedData.map((item)=>Todo.fromJson(jsonDecode(item))).toList();
          
      }
    });
  }

  // complete task function
  void completeSelectedTask() {
    setState(() {
      List<Todo> selectedTodos = todos.where((todo) => todo.selected).toList();

      for (var todo in selectedTodos) {
        todo.done = true;
        todo.selected = false;
      }

      completedTodos.addAll(selectedTodos);

      todos.removeWhere((todo) => todo.done);
    });
    saveTodos();
  }

  // Edit function
  void showEditDialog(int index) {
    TextEditingController editController = TextEditingController(
      text: todos[index].title,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todos[index].title = editController.text;
                },
                );
                saveTodos();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "Todo App",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 66, 168, 252),
        actions: [
          IconButton(
            onPressed: () async{
              final prefs =await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", false);
              Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route)=>false);
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             Align(
              alignment: Alignment.centerRight,
               child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompletedPage(todos: completedTodos, onUpdate: saveTodos),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      
                    ),
                    child: Text("View Completed Task"),
                    
                  ),
             ),
                SizedBox(height: 10,),
            todoTextField(),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(height: 20),
                ElevatedButton( 
                  onPressed: () {
                    if (textController.text.isEmpty) return;
                    setState(() {
                      todos.add(Todo(title: textController.text));
                    });
                    saveTodos();
                    textController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 24, 90, 165),
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Add"),
                ),
              ],
            ),

            SizedBox(height: 20),
            Expanded(child: todoList()),
            SizedBox(height: 20),
            if (todos.any((todo) => todo.selected == true))
              ElevatedButton(
                onPressed: () {
                  completeSelectedTask();
                },
                child: Text("Complete Selected"),
              ),
          ],
        ),
      ),
    );
  }

  ListView todoList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Checkbox(
              value: todos[index].selected,
              onChanged: (value) {
                setState(() {
                  todos[index].selected = value ?? false;
                });
                saveTodos();
              },
            ),
            title: Text(
              todos[index].title,
              style: TextStyle(
                fontSize: 20,
                color: todos[index].selected ? Colors.red : Colors.black,
                decoration: todos[index].selected
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.red,
              ),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showEditDialog(index);
                  },
                  icon: Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    showDeleteDialog(
                      context: context,
                      onConfirm: () {
                        setState(() {
                          todos.removeAt(index);
                        });
                        saveTodos();
                      },
                    );
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextField todoTextField() {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        labelText: "Enter todo",
        hintText: "Write something",
        border: OutlineInputBorder(),
      ),
    );
  }
}
