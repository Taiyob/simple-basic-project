import 'package:flutter/material.dart';
import 'package:simple_crud/add_new_todo_screen.dart';
import 'package:simple_crud/edit_todo_screen.dart';
import 'package:simple_crud/todo.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todoList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Visibility(
        visible: todoList.isNotEmpty,
        replacement: const Center(child: Text('Todo list empty'),),
        child: ListView.separated(
            itemCount: todoList.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey.shade200,
                height: 12,
                indent: 16,
                endIndent: 16,
              );
            },
            itemBuilder: (context, index) {
              return _buildTodoListTile(index);
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTodoFAB,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }

  ListTile _buildTodoListTile(int index) {
    return ListTile(
              title: Text(todoList[index].title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todoList[index].description),
                  Text(todoList[index].dateTime.toString()),
                ],
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () => showDeleteConfirmationDialog(index),
                      icon: const Icon(Icons.delete)),
                  IconButton(
                      onPressed: () => _onTapEditTodo(index),
                      icon: const Icon(Icons.edit)),
                ],
              ),
            );
  }

  void showDeleteConfirmationDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Todo'),
            content: const Text('Are you sure you want to delete it?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _removeTodo(index);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        });
  }

  void _removeTodo(int index){
    todoList.removeAt(index);
    setState(() {});
  }

  Future<void> _onTapAddNewTodoFAB() async {
    final Todo? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTodoScreen()),
    );
    if (result != null) {
      todoList.add(result);
      setState(() {});
    }
  }

  Future<void> _onTapEditTodo(int index) async {
    final Todo? updatedTodo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditTodoScreen(
                todo: todoList[index],
              )),
    );
    if (updatedTodo != null) {
      todoList[index] = updatedTodo;
      setState(() {});
    }
  }
}
