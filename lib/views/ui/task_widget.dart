import 'package:flutter/material.dart';
import 'package:todolist/models/task.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.black,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Text(
            widget.task.title,
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 16
            )
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            child: Text(widget.task.description),
            decoration: BoxDecoration(
              color: Colors.black38
            )
          ),
          Row(
            children: <Widget>[
              Text(widget.task.dateLimit.toString().substring(0,10)),
              Spacer(),
              Text(
                widget.task.isFinished
                  ? 'Finished'
                  : 'Not finished'
              )
            ]
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.update),
                color: Colors.teal,
              ),
              Spacer(),
              IconButton(
                onPressed: (){},
                icon: const Icon(Icons.delete),
                color: Colors.red,
              )
            ]
          )
        ],
      ),
    );
  }
}
