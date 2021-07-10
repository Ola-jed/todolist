import 'dart:convert' show jsonDecode;
import 'package:todolist/api/api_base.dart';
import 'package:todolist/models/task.dart';

class TaskService extends ApiBase {
  static final tasksUrl = ApiBase.apiUrl + 'tasks/';
  String token;

  TaskService(this.token);

  /// Call the api to get all the tasks created by the user
  /// Iterate on the json result to build a list of tasks
  ///
  /// ### Params (all optional)
  ///
  /// - offset : offset for pagination
  /// - limit : limit for query
  Future<List> getTasks([int offset = 0, int limit = 0]) async {
    var data = '{"offset":$offset,"limit":$limit}';
    var results = await getUrl(Uri.parse(tasksUrl), data, token);
    var jsonContent = jsonDecode(results);
    var listTasks = <Task>[];
    (jsonContent['data'] as List).forEach((element) {
      listTasks.add(Task.fromJson(element));
    });
    return listTasks;
  }

  Future<>

  /// Get a specific task with its slug
  ///
  /// ### Params
  /// - slug : The slug for the research
  Future<Task> getTask(String slug) async{
    var taskAsJson = await getUrl(Uri.parse(tasksUrl+slug),'',token);
    var task = Task.fromJson(jsonDecode(taskAsJson));
    return task;
  }
}
