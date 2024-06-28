import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../models/token_model.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String usernameError = '';
  String emailError = '';
  String passwordError = '';

  void registerUser() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validate inputs
    setState(() {
      usernameError = username.isEmpty ? 'Please enter username' : '';
      emailError = !EmailValidator.validate(email) ? 'Invalid email format' : '';
      passwordError = (password.length < 4 || password.length > 8) ? 'Password must be between 4 and 8 characters' : '';
    });

    if (usernameError.isNotEmpty || emailError.isNotEmpty || passwordError.isNotEmpty) {
      return;
    }

    User user = User(username: username, email: email, password: password);

    try {
      Token? token = await ApiService().registerUser(user);
      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token.accessToken);
        print('Token saved: ${token.accessToken}');
        _showSuccessDialog('Registration successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        print('Registration failed: Token is null');
        _showErrorDialog('Registration failed', 'Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Registration failed', 'An error occurred: $e');
      print('Error: $e');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
                    actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        title: Text('Register'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text('Username'),
            SizedBox(height: 5),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Username',
                errorText: usernameError.isNotEmpty ? usernameError : null,
              ),
            ),
            SizedBox(height: 10),
            Text('Email'),
            SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Email',
                errorText: emailError.isNotEmpty ? emailError : null,
              ),
            ),
            SizedBox(height: 10),
            Text('Password (4-8 characters)'),
            SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Password',
                errorText: passwordError.isNotEmpty ? passwordError : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

