import 'package:flutter/material.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/views/forms/task_form.dart';
import 'package:todolist/views/screens/task_screen.dart';

/// Widget to show tasks on home screen
class TaskWidget extends StatefulWidget {
  final Task task;
  final Function onDelete;

  const TaskWidget({
    Key? key,
    required this.task,
    required this.onDelete,
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
        color: Theme.of(context).colorScheme.surface,
      ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
                    final hasMarked = await TaskService()
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: TaskForm(
                            task: widget.task,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text($(context).deleteTask),
                          content: Text(
                            $(context).deleteTaskQuestion,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final hasDeleted = await TaskService()
                                    .deleteTask(widget.task.slug);
                                if (hasDeleted) {
                                  Navigator.pop(ctx);
                                  widget.onDelete();
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
                              onPressed: () => Navigator.pop(ctx),
                              child: Text($(context).no),
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
