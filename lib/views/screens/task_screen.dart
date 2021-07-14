import 'package:flutter/material.dart';
import 'package:todolist/models/task.dart';

/// Our task screen <br>
/// We display a task and all of its steps <br>
/// The task is read-only meanwhile the steps are modifiable/deletable
class TaskScreen extends StatefulWidget {
  final Task task;
  const TaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(

    );
  }
}
