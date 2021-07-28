import 'package:flutter/material.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/views/forms/task_form.dart';
import 'package:todolist/views/screens/task_screen.dart';

/// Widget to show tasks on home screen
class TaskWidget extends StatefulWidget {
  final Task task;
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.tealAccent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskScreen(task: widget.task)
          )
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF1C1C1C)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10,top: 10),
              child: Text(
                widget.task.title,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                )
              )
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              child: Text(
                widget.task.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15)
              )
            ),
            Row(
              children: <Widget>[
                Text(widget.task.dateLimit.toString().substring(0,10)),
                Spacer(),
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: const Text('Finished ? '),
                    value: widget.task.isFinished,
                    activeColor: Colors.black,
                    onChanged: (value) async {
                      /// Mark as (un)finished
                      final String token = await getToken();
                      final bool hasMarked = await TaskService(token).finishTask(widget.task.slug, value!);
                      if(hasMarked) {
                        setState(() {
                          widget.task.isFinished = !widget.task.isFinished;
                        });
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: const Text('Could not update this task')
                          )
                        );
                      }
                    }
                  )
                )
              ]
            ),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Scaffold(
                          body: TaskForm(task: widget.task)
                        );
                      }
                    );
                  },
                  icon: const Icon(Icons.update),
                  color: Colors.teal,
                ),
                Spacer(),
                IconButton(
                  /// We delete and remove this task
                  onPressed: () async{
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete task ?'),
                          content: const Text('Do you want to delete this task ?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final String token = await getToken();
                                final hasDeleted = await TaskService(token).deleteTask(widget.task.slug);
                                if(hasDeleted) {
                                  dispose();
                                  Navigator.pushNamed(context, '/');
                                }
                                else{
                                  showDialog(
                                    context: context,
                                    builder:(context) {
                                      return const AlertDialog(
                                        title: const Text('Task deletion'),
                                        content: const Text('Could not delete task')
                                      );
                                    }
                                  );
                                }
                              },
                              child: const Text('Yes')
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context,true);
                              },
                              child: const Text('No')
                            )
                          ]
                        );
                      }
                    );
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.red
                )
              ]
            )
          ]
        )
      )
    );
  }
}



