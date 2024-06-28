import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_wtih_api/globals.dart';
import 'package:todo_app_wtih_api/models/token_model.dart';
import '../models/user.dart';
import '../models/todo.dart';

class ApiService {

  Future<Token?> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': user.username,
        'email': user.email,
        'password': user.password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print('JSON Response: $jsonResponse');
      if (jsonResponse.containsKey('accessToken')) {
        return Token.fromJson(jsonResponse);
      } else {
        print('Token key not found in JSON response');
        return null;
      }
    } else {
      print('Failed to register: ${response.body}');
      return null;
    }
  }

  Future<Token?> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String? token = jsonResponse['accessToken'];
      print('Token: $token');

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('jwt_token', token);

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String userId = decodedToken['sub']; // 'sub' kullanıcının ID'sini temsil eder
        prefs.setString('user_id', userId);

        return Token.fromJson(jsonResponse);
      } else {
        print('Token is null');
        return null;
      }
    } else {
      print('Failed to login: ${response.body}');
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
  }
/*
  Future<List<Todo>> getTodosByUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print('Todos Response status: ${response.statusCode}');
    print('Todos Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to fetch todos');
    }
  }
*/
  Future<List<Todo>> getTodosByUser( String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print('Todos Response status: ${response.statusCode}');
    print('Todos Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to fetch todos');
    }
  }


  //adres satırında useridler eklendi


  Future<void> addTodo(Todo todo, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(todo.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }
  Future<void> toggleTodoStatus(Todo todo, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/todos/${todo.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'todoName': todo.todoName,
        'completed': todo.completed,
      }),
    );

    print('Toggle Status Response status: ${response.statusCode}');
    print('Toggle Status Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo status');
    }
  }

  Future<void> deleteTodo(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
