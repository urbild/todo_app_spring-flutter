import 'package:flutter/foundation.dart';
import 'todo.dart';

class TodosData extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  void setTodos(List<Todo> todos) {
    _todos = todos;
    notifyListeners();
  }

  void toggleTodoStatus(Todo todo) {
    final index = _todos.indexOf(todo);
    if (index != -1) {
      _todos[index].completed = !_todos[index].completed;
      notifyListeners();
    }
  }

  void updateTodoStatus(Todo updatedTodo) {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
    }
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    notifyListeners();
  }

  void deleteTodo(Todo todo) {
    _todos.remove(todo);
    notifyListeners();
  }
  
}
