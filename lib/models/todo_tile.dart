import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/todo.dart';
import '../models/todos_data.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final TodosData todosData;

  const TodoTile({Key? key, required this.todo, required this.todosData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.todoName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: todo.completed,
            onChanged: (bool? value) async {
              if (value != null) {
                try {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? token = prefs.getString('jwt_token');
                  if (token != null) {
                    todo.completed = value;
                    await ApiService().toggleTodoStatus(todo, token);
                    todosData.updateTodoStatus(todo);
                  } else {
                    print('Token not found');
                  }
                } catch (e) {
                  print('Failed to update todo status: $e');
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('jwt_token');
                if (token != null) {
                  await ApiService().deleteTodo(todo.id, token);
                  todosData.deleteTodo(todo);
                } else {
                  print('Token not found');
                }
              } catch (e) {
                print('Failed to delete todo: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
