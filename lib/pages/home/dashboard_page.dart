import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/weather_model.dart';
import 'package:todo_app/widgets/dashboard_header.dart';
import 'todo_page.dart';
import '../../models/todo_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool projectExpanded = true;

  // List<Todo> todos = [];
  // List<Todo> completedTodos = [];
  // WeatherModel? weather;
  // bool isLoadingWeather = true;
  @override
  void initState() {
    super.initState();
    // loadTodos();
  }

  // void loadTodos() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   List<String>? data = prefs.getStringList("todos");
  //   List<String>? completedData = prefs.getStringList("completed_todos");
  //   setState(() {
  //     if (data != null) {
  //       todos = data.map((e) => Todo.fromJson(jsonDecode(e))).toList();
  //     }
  //     if (completedData != null) {
  //       completedTodos = completedData
  //           .map((e) => Todo.fromJson(jsonDecode(e)))
  //           .toList();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 234, 234),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TodoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          DashboardHeader(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dashboardCard(title: "List", icon: Icons.list_outlined),
                    _dashboardCard(
                      title: "Calendar",
                      icon: Icons.calendar_month,
                    ),
                    _dashboardCard(title: "Reports", icon: Icons.view_kanban),
                  ],
                ),
                SizedBox(height: 12),
                Column(children: [

                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard({required String title, required IconData icon}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 61, 41, 116),
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          child: Container(
            width: 140,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: Color(0xFF666AF6), size: 42),
          ),
        ),
      ],
    );
  }

  void onToggle() {}
}

class SectionHeader extends StatelessWidget {

  const SectionHeader({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("title", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey),),
        Row(
          children: [

            IconButton(
              onPressed: (){}, 
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade500,
              ),
            ),

            IconButton(onPressed: (){}, 
            icon: Icon(
              Icons.add,
              color: Colors.grey.shade500,
              )
            )
          ],
        )
      ],
    );
  }
}
