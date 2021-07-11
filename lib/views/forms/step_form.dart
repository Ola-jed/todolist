import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:todolist/models/step.dart' as StepData;

/// Our step creation and update form
class StepForm extends StatefulWidget {
  const StepForm({Key? key}) : super(key: key);

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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    var step = StepData.Step(title, priority);
                    print(step.toJson());
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
