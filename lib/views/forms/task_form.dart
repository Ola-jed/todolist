import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:slugify/slugify.dart';
import 'package:todolist/models/task.dart';

/// Our task creation and update form
class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  int priority = 1;
  bool hasSteps = false;
  var data = Map<String,dynamic>();

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
                'Task',
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: TextFormField(
                onSaved: (value) => data['title'] = value,
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
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'Description',
                  prefixIcon: Icon(Icons.description)
                ),
                onSaved: (value) => data['description'] = value,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                minLines: 1,
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'The description field is required';
                  }
                  return null;
                }
              )
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: TextFormField(
                controller: dateController,
                readOnly: true,
                onSaved: (value) => data['date_limit'] = value,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'Date limit',
                  prefixIcon: Icon(Icons.date_range),
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'The date limit field is required';
                  }
                  return null;
                },
                onTap: () async {
                  var date =  await showDatePicker(
                    context: context,
                    initialDate:DateTime.now(),
                    firstDate:DateTime(2021),
                    lastDate: DateTime(2030)
                  );
                  dateController.text = date.toString().substring(0,10);
                  data['date_limit'] = date.toString().substring(0,10);
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
                ),
              )
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    onChanged: (bool? value) {
                      setState(() {
                        hasSteps = value!;
                      });
                    },
                    value: hasSteps,
                    checkColor: Colors.teal,
                    fillColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                  ),
                  Expanded(
                    child: const Text('Has steps ?')
                  )
                ],
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
                    data['slug'] = slugify(data['title']);
                    data['priority'] = priority;
                    data['has_steps'] = hasSteps;
                    data['is_finished'] = false;
                    var task = Task.fromJson(data);
                    print(task.toJson());
                    // TODO : handle data
                  }
                },
                child: const Text('Create task'),
              )
            )
          ]
        ),
      )
    );
  }
}
