import 'package:flutter/material.dart';
import 'package:todolist/views/forms/task_form.dart';

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
        body: TaskForm(),
      ),
    );
  }
}