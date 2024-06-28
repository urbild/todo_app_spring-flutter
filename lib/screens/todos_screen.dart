import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_wtih_api/screens/login_screen.dart';
import '../services/api_service.dart';
import '../models/todo.dart';
import '../models/todo_tile.dart';
import '../models/todos_data.dart';
import 'add_todo_screen.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      if (token != null) {
        List<Todo> fetchedTodos = await ApiService().getTodosByUser(token);
        Provider.of<TodosData>(context, listen: false).setTodos(fetchedTodos);
      }
    } catch (e) {
      print('Failed to fetch todos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> confirmLogout() async {
    bool? shouldLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await logout();
    }
  }

  Future<void> logout() async {
    await ApiService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<bool?> confirmDelete(Todo todo) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todos (${Provider.of<TodosData>(context).todos.length})',
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: confirmLogout,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<TodosData>(
                builder: (context, todosData, child) {
                  return todosData.todos.isEmpty
                      ? const Center(
                          child: Text('No todos available.'),
                        )
                      : ListView.builder(
                          itemCount: todosData.todos.length,
                          itemBuilder: (context, index) {
                            Todo todo = todosData.todos[index];
                            return Dismissible(
                              key: Key(todo.id.toString()),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) =>
                                  confirmDelete(todo),
                              onDismissed: (direction) {
                                Provider.of<TodosData>(context, listen: false)
                                    .deleteTodo(todo);
                              },
                              background: Container(
                                color: Colors.red,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.centerEnd,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: TodoTile(
                                todo: todo,
                                todosData: todosData,
                              ),
                            );
                          },
                        );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddTodoScreen();
            },
          );
        },
      ),
    );
  }
}
