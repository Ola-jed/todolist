import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:todolist/api/step_service.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/models/step.dart' as StepData;
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/views/screens/task_screen.dart';

/// Our step creation and update form
class StepForm extends StatefulWidget {
  final StepData.Step? step;
  final String taskSlug;

  const StepForm({
    Key? key,
    required this.taskSlug,
    this.step,
  }) : super(key: key);

  @override
  _StepFormState createState() => _StepFormState();
}

class _StepFormState extends State<StepForm> {
  final _formKey = GlobalKey<FormState>();
  int priority = 1;
  var title = '';

  @override
  Widget build(BuildContext context) {
    final hasStep = widget.step != null;
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                $(context).step,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                initialValue: hasStep ? widget.step!.title : null,
                onSaved: (value) => title = value!,
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
              child: SpinBox(
                value: 1,
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
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  side: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final step = StepData.Step(title, priority);
                    var hasCreated = false;
                    final stepService = StepService();
                    final taskService = TaskService();
                    if (widget.step == null) {
                      hasCreated = await stepService
                          .createStep(widget.taskSlug, step);
                    } else {
                      hasCreated = await stepService
                          .updateStep(widget.step!.id, step);
                    }
                    if (hasCreated) {
                      final task = await taskService.getTask(widget.taskSlug);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskScreen(task: task),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text($(context).stepCreation),
                            content: Text(
                              $(context).couldNotCreateOrUpdateStep,
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                child: Text(
                  hasStep ? $(context).updateStep : $(context).createStep,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
