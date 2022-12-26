import 'package:flutter/material.dart';
import 'package:todolist/views/forms/task_form.dart';

class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TaskForm());
  }
}
