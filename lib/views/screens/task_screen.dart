import 'package:flutter/material.dart';
import 'package:todolist/api/step_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/step.dart' as StepData;
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/utils/tasks_scheduler.dart';
import 'package:todolist/utils/todolist_theme.dart';
import 'package:todolist/views/forms/step_form.dart';
import 'package:todolist/views/ui/routes.dart';
import 'package:todolist/views/ui/step_widget.dart';

/// Our task screen <br>
/// We display a task and all of its steps <br>
/// The task is read-only meanwhile the steps are modifiable/deletable
class TaskScreen extends StatelessWidget {
  final Task task;

  const TaskScreen({Key? key, required this.task}) : super(key: key);

  /// We retrieve all the steps of a task
  Future<List> _getSteps() async {
    final token = await getToken();
    return await StepService(token).getStepsFromTask(task.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, Routes.home),
        ),
        title: Text(task.title),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: false,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(color: Colors.black38),
                  child: Text(
                    task.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    task.description,
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${$(context).priority} : ${task.priority}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${$(context).dateLimit} : ${task.dateLimit.toString().substring(0, 10)}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: CheckboxListTile(
                    onChanged: null,
                    contentPadding: EdgeInsets.all(0),
                    title: Text($(context).finished),
                    value: task.isFinished,
                    activeColor: Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await scheduleTask(task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text($(context).reminderDefined),
                        ),
                      );
                    } on Exception {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text($(context).couldNotDefineReminder),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.add_alarm),
                  label: Text($(context).defineReminder),
                  style: TodolistTheme.primaryBtn(),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          FutureBuilder(
            future: _getSteps(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final steps = snapshot.data as List<StepData.Step>;
                if (steps.isEmpty) {
                  return Center(
                    child: Text(
                      $(context).noStepFound,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    return StepWidget(
                      step: steps[index],
                      taskSlug: task.slug,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      $(context).taskDoesNotHaveSteps,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: task.hasSteps
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Scaffold(body: StepForm(taskSlug: task.slug));
                  },
                );
              },
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
