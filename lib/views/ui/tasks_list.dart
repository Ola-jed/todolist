import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/views/ui/task_widget.dart';

/// Type of tasks we want to show
/// Will be passed to the constructor
enum TasksFillType{All,Search,Finished,Unfinished,Expired}

/// List of tasks
/// Built depending on the type of filling
class TasksList extends StatefulWidget {
  final TasksFillType tasksFillType;
  TasksList({required this.tasksFillType,Key? key}) : super(key: key);

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {

  Future<List> _getCorrespondingTasks() async {
    var preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var taskService = TaskService(token!);
    switch(widget.tasksFillType){
      case TasksFillType.All :
        return taskService.getTasks();
      case TasksFillType.Finished:
        return taskService.getFinishedTasks(true);
      case TasksFillType.Unfinished:
        return taskService.getFinishedTasks(false);
      case TasksFillType.Expired:
        return taskService.getExpiredTasks();
      case TasksFillType.Search:
        // TODO: Handle this case.
        return taskService.getTasks();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCorrespondingTasks(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
            itemCount: (snapshot.data as List<Task>).length,
            itemBuilder: (context,index) {
              return TaskWidget(task: (snapshot.data as List<Task>)[index]);
            }
          );
        }
        else if(snapshot.hasError) {
          return Center(
            child: Text(
              'Something weird happened',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white,fontSize: 16)
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
    );
  }
}
