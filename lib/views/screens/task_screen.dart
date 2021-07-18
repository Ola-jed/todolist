import 'package:flutter/material.dart';
import 'package:todolist/api/step_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/step.dart' as StepData;
import 'package:todolist/utils/tasks_scheduler.dart';
import 'package:todolist/views/forms/step_form.dart';
import 'package:todolist/views/ui/step_widget.dart';

/// Our task screen <br>
/// We display a task and all of its steps <br>
/// The task is read-only meanwhile the steps are modifiable/deletable
class TaskScreen extends StatelessWidget {
  final Task task;
  const TaskScreen({Key? key, required this.task}) : super(key: key);

  /// We retrieve all the steps of a task
  Future<List> _getSteps() async {
    var token = await getToken();
    return await StepService(token).getStepsFromTask(task.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          }
        ),
        title: Text(task.title)
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        children:<Widget> [
          Container(
            padding: EdgeInsets.only(left: 5,right: 5),
            margin: EdgeInsets.only(left: 5,right: 5,bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 3
                )
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: Colors.black38
                  ),
                  child: Text(
                    task.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 5,bottom: 15),
                  child: Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 17
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Priority : ${task.priority}',
                        style: const TextStyle(
                          fontSize: 17
                        )
                      ),
                      Spacer(),
                      Text(
                        'Date limit : ${task.dateLimit.toString().substring(0,10)}',
                        style: const TextStyle(
                          fontSize: 17
                        )
                      )
                    ]
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child: CheckboxListTile(
                    onChanged: (value){},
                    contentPadding: EdgeInsets.all(0),
                    title: const Text('Finished ? '),
                    value: task.isFinished,
                    activeColor: Colors.black
                  )
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try{
                      await scheduleTask(task);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Reminder defined')));
                    }
                    on Exception catch (e,stack) {
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Could not define reminder')));
                    }
                  },
                  icon: Icon(Icons.add_alarm),
                  label: const Text('Define reminder'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal
                  )
                )
              ]
            )
          ),
          FutureBuilder(
            future: _getSteps(),
            builder: (context,snapshot) {
              if(snapshot.hasData) {
                if((snapshot.data as List).isEmpty) {
                  return Center(
                    child: Text(
                      'No step found',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,fontSize: 16)
                    )
                  );
                }
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (snapshot.data as List<StepData.Step>).length,
                  itemBuilder: (context,index) {
                    return StepWidget(
                      step: (snapshot.data as List<StepData.Step>)[index],
                      taskSlug: task.slug
                    );
                  }
                );
              }
              else if(snapshot.hasError) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 5,bottom: 5),
                    child: const Text(
                      'This task does not have steps',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,fontSize: 16)
                    )
                  )
                );
              }
              else {
                return Center(
                  child: Container(
                    child: CircularProgressIndicator()
                  )
                );
              }
            }
          )
        ]
      ),
      floatingActionButton: task.hasSteps
        ? FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Scaffold(
                    body: StepForm(taskSlug: task.slug)
                  );
                }
              );
            },
            backgroundColor: Colors.teal,
            child: const Icon(Icons.add)
        )
        : null
    );
  }
}