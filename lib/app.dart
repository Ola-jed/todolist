import 'package:flutter/material.dart';
import 'package:todolist/views/forms/signup_form.dart';
import 'package:todolist/views/forms/step_form.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignupForm(),
      ),
    );
  }
}