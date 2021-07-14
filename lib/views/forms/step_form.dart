import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:todolist/api/step_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/step.dart' as StepData;

/// Our step creation and update form
/// TODO : handle update case
class StepForm extends StatefulWidget {
  final StepData.Step? step;
  final String taskSlug;
  const StepForm({Key? key, required this.taskSlug, this.step}) : super(key: key);

  @override
  _StepFormState createState() => _StepFormState();
}

class _StepFormState extends State<StepForm> {
  final _formKey = GlobalKey<FormState>();
  int priority = 1;
  var title = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: const Text(
                'Step',
                style: const TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: TextFormField(
                onSaved: (value) => title = value!,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'Title',
                  prefixIcon: Icon(Icons.title)
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'The title field is required';
                  }
                  return null;
                }
              )
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: SpinBox(
                value: 1,
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'The priority field is required';
                  }
                },
                onChanged: (value) => priority = value.toInt(),
                min: 1,
                max: 10,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  filled: true
                )
              )
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.teal,
                  side: BorderSide(color: Colors.black, width: 1)
                ),
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var step = StepData.Step(title, priority);
                    var token = await getToken();
                    var hasCreated = false;
                    if(widget.step == null) {
                      // Create a new step
                      hasCreated = await StepService(token).createStep(widget.taskSlug, step);
                    }
                    else {
                      // Update the step
                      hasCreated = await StepService(token).updateStep(widget.step!.id, step);
                    }
                    // TODO : handle data
                  }
                },
                child: const Text('Create step')
              )
            )
          ]
        ),
      )
    );
  }
}
