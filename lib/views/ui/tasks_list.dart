import 'package:flutter/material.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/views/ui/task_widget.dart';

/// Type of tasks we want to show
/// Will be passed to the constructor
enum TasksFillType { All, Search, Finished, Unfinished, Expired }

/// List of tasks
/// Built depending on the type of filling
class TasksList extends StatefulWidget {
  final String searchContent;
  final TasksFillType tasksFillType;

  TasksList({
    required this.tasksFillType,
    this.searchContent = '',
    Key? key,
  }) : super(key: key);

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  /// Load correctly the tasks depending on the fill type
  /// All : all tasks of the user
  /// Finished : All the finished tasks of the user
  /// Unfinished : All the tasks not yet finished by the user
  /// Expired : Get the expired tasks (limit date passed)
  /// Search : Search the tasks corresponding to searchContent
  Future<List> _getCorrespondingTasks() async {
    final token = await getToken();
    if (token.isEmpty) return [];
    var taskService = TaskService();
    switch (widget.tasksFillType) {
      case TasksFillType.All:
        return taskService.getTasks();
      case TasksFillType.Finished:
        return taskService.getFinishedTasks(finished: true);
      case TasksFillType.Unfinished:
        return taskService.getFinishedTasks(finished: false);
      case TasksFillType.Expired:
        return taskService.getExpiredTasks();
      case TasksFillType.Search:
        if (widget.searchContent.isNotEmpty) {
          return taskService.searchTasks(widget.searchContent);
        } else {
          return taskService.getTasks();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCorrespondingTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final tasks = snapshot.data as List<Task>;
          if (tasks.isEmpty) {
            return Center(
              child: Text(
                $(context).noTask,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) => TaskWidget(task: tasks[index]),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              $(context).anErrorOccurred,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 17,
              ),
            ),
          );
        } else {
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
