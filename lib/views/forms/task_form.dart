import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:slugify/slugify.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/utils/todolist_theme.dart';
import 'package:todolist/views/ui/routes.dart';

/// Our task creation and update form
class TaskForm extends StatefulWidget {
  final Task? task;

  const TaskForm({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  int priority = 1;
  bool hasSteps = false;
  bool _loading = false;
  var data = Map<String, dynamic>();

  @override
  Widget build(BuildContext context) {
    final hasTask = widget.task != null;
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                initialValue: hasTask ? widget.task!.title : null,
                onSaved: (value) => data['title'] = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: $(context).title,
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return $(context).titleRequired;
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                initialValue: hasTask ? widget.task!.description : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: $(context).description,
                  prefixIcon: Icon(Icons.description),
                ),
                onSaved: (value) => data['description'] = value,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                minLines: 1,
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return $(context).descriptionRequired;
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                controller: dateController,
                readOnly: true,
                onSaved: (value) => data['date_limit'] = value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: $(context).dateLimit,
                  prefixIcon: Icon(Icons.date_range),
                ),
                validator: (value) {
                  if (value == null || value.length < 10) {
                    return $(context).dateLimitRequired;
                  }
                  return null;
                },
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2030),
                  );
                  if (date.toString().length >= 10) {
                    final stringDateValue = date.toString().substring(0, 10);
                    dateController.text = stringDateValue;
                    data['date_limit'] = stringDateValue;
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: SpinBox(
                value: hasTask ? widget.task!.priority.toDouble() : 1,
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return $(context).priorityRequired;
                  }
                  return null;
                },
                onChanged: (value) => priority = value.toInt(),
                min: 1,
                max: 10,
                decoration: InputDecoration(
                  labelText: $(context).priority,
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    onChanged: (bool? value) {
                      setState(() => hasSteps = value!);
                    },
                    value: hasSteps,
                    checkColor: Theme.of(context).colorScheme.primary,
                    fillColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Expanded(
                    child: Text($(context).hasSteps),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                style: TodolistTheme.primaryBtn(),
                onPressed: _loading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => _loading = true);
                          data['slug'] = slugify(data['title']);
                          data['priority'] = priority;
                          data['has_steps'] = hasSteps;
                          data['is_finished'] = false;
                          final task = Task.fromJson(data);
                          final token = await getToken();
                          final taskService = TaskService(token);
                          var hasCreated = false;
                          hasCreated = hasTask
                              ? await taskService.updateTask(
                                  widget.task!.slug,
                                  task,
                                )
                              : await taskService.createTask(task);
                          if (hasCreated) {
                            Navigator.pushNamed(context, Routes.home);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    hasTask
                                        ? $(context).taskUpdate
                                        : $(context).taskCreation,
                                  ),
                                  content: Text(
                                    hasTask
                                        ? $(context).couldNotUpdateTask
                                        : $(context).couldNotCreateTask,
                                  ),
                                );
                              },
                            );
                          }
                          setState(() => _loading = false);
                        }
                      },
                child: _loading
                    ? CircularProgressIndicator()
                    : Text(
                        hasTask ? $(context).updateTask : $(context).createTask,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
