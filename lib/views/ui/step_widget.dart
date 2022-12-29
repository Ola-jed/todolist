import 'package:flutter/material.dart';
import 'package:todolist/api/step_service.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/models/step.dart' as StepData;
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/views/forms/step_form.dart';
import 'package:todolist/views/screens/task_screen.dart';

/// A widget to show a step
class StepWidget extends StatefulWidget {
  final StepData.Step step;
  final String taskSlug;

  const StepWidget({
    Key? key,
    required this.step,
    required this.taskSlug,
  }) : super(key: key);

  @override
  _StepWidgetState createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              widget.step.title,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 15,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  '${$(context).priority} : ${widget.step.priority}',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Spacer(),
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text('${$(context).finished} ? '),
                  value: widget.step.isFinished,
                  activeColor: Colors.black,
                  onChanged: (value) async {
                    final hasMarked =
                        await StepService().finishStep(widget.step.id, value!);
                    if (hasMarked) {
                      setState(() {
                        widget.step.isFinished = !widget.step.isFinished;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text($(context).couldNotUpdateStep),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          body: StepForm(
                            taskSlug: widget.taskSlug,
                            step: widget.step,
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
              ),
              IconButton(
                onPressed: () async {
                  final hasDeleted =
                      await StepService().deleteStep(widget.step.id);
                  if (hasDeleted) {
                    final task = await TaskService().getTask(widget.taskSlug);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskScreen(task: task),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text($(context).stepDeletion),
                          content: Text($(context).couldNotDeleteStep),
                        );
                      },
                    );
                  }
                },
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
