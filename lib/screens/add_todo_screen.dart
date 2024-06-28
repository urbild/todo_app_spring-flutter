import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../services/api_service.dart';
import '../models/todos_data.dart';
import '../models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  String todoTitle = "";
  final Uuid uuid = Uuid(); 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Text(
            'Add Todo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.green,
            ),
          ),
          TextField(
            autofocus: true,
            onChanged: (val) {
              todoTitle = val;
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              if (todoTitle.isNotEmpty) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString('jwt_token');
                String? userId = prefs.getString('user_id');
                if (token != null && userId != null) {
                  Todo newTodo = Todo(
                    id: uuid.v4(),
                    todoName: todoTitle,
                    completed: false,
                    createdAt: DateTime.now(),
                  );
                  try {
                    ApiService apiService = ApiService();
                    await apiService.addTodo(newTodo, token);
                    Provider.of<TodosData>(context, listen: false).addTodo(newTodo);
                    Navigator.pop(context);
                  } catch (e) {
                    print('Failed to add todo: $e');
                  }
                } else {
                  print('Token not found');
                }
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }
}
