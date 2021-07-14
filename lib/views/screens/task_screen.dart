import 'package:flutter/material.dart';
import 'package:todolist/models/task.dart';

/// Our task screen <br>
/// We display a task and all of its steps <br>
/// The task is read-only meanwhile the steps are modifiable/deletable
class TaskScreen extends StatefulWidget {
  final Task task;
  const TaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: Column(
        children:<Widget> [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(top: 5,bottom: 5),
            decoration: BoxDecoration(
              color: Colors.transparent,
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
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child: Text(
                    widget.task.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline
                    )
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: 5,bottom: 5),
                  child: Text(
                    widget.task.description,
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
                        'Priority : ${widget.task.priority}',
                        style: const TextStyle(
                          fontSize: 17
                        )
                      ),
                      Spacer(),
                      Text(
                        'Date limit : ${widget.task.dateLimit.toString().substring(0,10)}',
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
                    value: widget.task.isFinished,
                    activeColor: Colors.black,
                  )
                )
              ]
            )
          ),
        ]
      )
    );
  }
}
