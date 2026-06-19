import 'package:flutter/material.dart';
import 'package:todo_app/widgets/delete_dialog.dart';
import '../../models/todo_model.dart';

class CompletedPage extends StatefulWidget {
  final List<Todo> todos;
  final VoidCallback onUpdate;
  CompletedPage({required this.todos,required this.onUpdate});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  Todo? lastDeleted;
  int? lastDeletedIndex;
  
  void showUndoSnackBar(String message, VoidCallback? onUndo) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        action: onUndo != null 
          ? SnackBarAction(label: "UNDO", onPressed: onUndo)
          : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CompletedTodos = widget.todos.where((todo) => todo.done == true).toList();
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'Completed Task',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: CompletedTodos.isEmpty 
              ? null // Disable button when empty
              : () {
                  showDeleteDialog(context: context, onConfirm: () {
                    setState(() {
                      widget.todos.removeWhere((todo) => todo.done);
                    });
                    showUndoSnackBar("All tasks cleared", null);
                  });
                }, 
            child: Text(
              "Clear All", 
              style: TextStyle(
                color: CompletedTodos.isEmpty ? Colors.grey : Colors.white
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 66, 168, 252),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: [
            if (CompletedTodos.isEmpty)
              SliverFillRemaining(
                child: Center(child: Text("No Completed Tasks")),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          CompletedTodos[index].title,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            showDeleteDialog(context: context, onConfirm: () {
                              final deletedItem = CompletedTodos[index];
                              final deletedIndex = widget.todos.indexOf(deletedItem);
                              
                              setState(() {
                                lastDeleted = deletedItem;
                                lastDeletedIndex = deletedIndex;
                                widget.todos.removeAt(deletedIndex);
                              });
                              widget.onUpdate();
                              
                              showUndoSnackBar("Task deleted", () {
                                setState(() {
                                  if (lastDeleted != null && lastDeletedIndex != null) {
                                    widget.todos.insert(lastDeletedIndex!, lastDeleted!);
                                    lastDeleted = null;
                                    lastDeletedIndex = null;
                                  }
                                });
                                widget.onUpdate();
                              });
                            });
                          }, 
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    );
                  },
                  childCount: CompletedTodos.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}