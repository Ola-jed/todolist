import 'package:flutter/material.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/views/forms/task_form.dart';
import 'package:todolist/views/screens/task_screen.dart';

/// Widget to show tasks on home screen
class TaskWidget extends StatefulWidget {
  final Task task;

  const TaskWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskScreen(
                task: widget.task,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                widget.task.title,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              child: Text(
                widget.task.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Row(children: <Widget>[
              Text(widget.task.dateLimit.toString().substring(0, 10)),
              Spacer(),
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text($(context).finished),
                  value: widget.task.isFinished,
                  activeColor: Colors.black,
                  onChanged: (value) async {
                    final token = await getToken();
                    final hasMarked = await TaskService(token)
                        .finishTask(widget.task.slug, value!);
                    if (hasMarked) {
                      setState(() {
                        widget.task.isFinished = !widget.task.isFinished;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text($(context).couldNotUpdateTask),
                        ),
                      );
                    }
                  },
                ),
              )
            ]),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Scaffold(
                          body: TaskForm(task: widget.task),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.update),
                  color: Colors.teal,
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text($(context).deleteTask),
                          content: Text(
                            $(context).deleteTaskQuestion,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final token = await getToken();
                                final hasDeleted = await TaskService(token)
                                    .deleteTask(widget.task.slug);
                                if (hasDeleted) {
                                  dispose();
                                  Navigator.pushNamed(context, '/');
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          $(context).taskDeletion,
                                        ),
                                        content: Text(
                                          $(context).couldNotDeleteTask,
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text($(context).yes),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text($(context).no),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
