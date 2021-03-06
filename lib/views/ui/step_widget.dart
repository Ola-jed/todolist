import 'package:flutter/material.dart';
import 'package:todolist/api/step_service.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/models/step.dart' as StepData;
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/views/forms/step_form.dart';
import 'package:todolist/views/screens/task_screen.dart';


/// A widget to show a step
class StepWidget extends StatefulWidget {
  final StepData.Step step;
  final String taskSlug;
  const StepWidget({Key? key, required this.step, required this.taskSlug}) : super(key: key);

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
        color: const Color(0xFF1C1C1C)
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
                fontSize: 15
              )
            )
          ),
          Row(
            children: <Widget>[
              Text(
                'Priority : ${widget.step.priority}',
                style: const TextStyle(fontSize: 15)
              ),
              Spacer(),
              Expanded(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: const Text('Finished ? '),
                  value: widget.step.isFinished,
                  activeColor: Colors.black,
                  onChanged: (value) async {
                    /// Mark as (un)finished
                    final token = await getToken();
                    final hasMarked = await StepService(token).finishStep(widget.step.id, value!);
                    if(hasMarked) {
                      setState(() {
                        widget.step.isFinished = !widget.step.isFinished;
                      });
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: const Text('Could not update this step')
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
                        body: StepForm(taskSlug: widget.taskSlug,step: widget.step)
                      );
                    }
                  );
                },
                icon: const Icon(Icons.update),
                color: Colors.teal,
              ),
              Spacer(),
              IconButton(
                /// We delete and remove this step
                onPressed: () async{
                  final token = await getToken();
                  final hasDeleted = await StepService(token).deleteStep(widget.step.id);
                  if(hasDeleted) {
                    // We redirect to the task screen but we get the task before
                    final task = await TaskService(token).getTask(widget.taskSlug);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskScreen(task: task)
                      )
                    );
                  }
                  else{
                    showDialog(
                      context: context,
                      builder:(context) {
                        return const AlertDialog(
                          title: Text('Step deletion'),
                          content: Text('Could not delete task step')
                        );
                      }
                    );
                  }
                },
                icon: const Icon(Icons.delete),
                color: Colors.red
              )
            ]
          )
        ]
      )
    );
  }
}
