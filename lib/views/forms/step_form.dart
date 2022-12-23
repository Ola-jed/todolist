import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:todolist/api/step_service.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/step.dart' as StepData;
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
              child: const Text(
                'Step',
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return 'The title field is required';
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
                    return 'The priority field is required';
                  }
                  return null;
                },
                onChanged: (value) => priority = value.toInt(),
                min: 1,
                max: 10,
                decoration: const InputDecoration(
                  labelText: 'Priority',
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
                    final token = await getToken();
                    final step = StepData.Step(title, priority);
                    var hasCreated = false;
                    if (widget.step == null) {
                      hasCreated = await StepService(token)
                          .createStep(widget.taskSlug, step);
                    } else {
                      hasCreated = await StepService(token)
                          .updateStep(widget.step!.id, step);
                    }
                    if (hasCreated) {
                      final task =
                          await TaskService(token).getTask(widget.taskSlug);
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
                          return const AlertDialog(
                            title: Text('Step creation'),
                            content: Text(
                              'Could not create/update the task step',
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                child: Text(
                  hasStep ? 'Update step' : 'Create step',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
