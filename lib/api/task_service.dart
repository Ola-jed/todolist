import 'dart:convert' show jsonEncode, jsonDecode;
import 'package:todolist/api/api_base.dart';
import 'package:todolist/models/task.dart';

/// Service that calls backend for tasks management
class TaskService extends ApiBase {
  static final tasksUrl = ApiBase.apiUrl + 'tasks/';
  String token;

  TaskService(this.token);

  /// Call the api to get all the tasks created by the user
  /// Iterate on the json result to build a list of tasks
  ///
  /// ### Params (all optional)
  /// - offset : offset for pagination
  /// - limit : limit for query
  Future<List<Task>> getTasks([int offset = 0, int limit = 0]) async {
    final data = '{"offset":$offset,"limit":$limit}';
    var results = await getUrl(Uri.parse(tasksUrl), data, token);
    var jsonContent = jsonDecode(results);
    var listTasks = <Task>[];
    (jsonContent['data'] as List).forEach((element) {
      listTasks.add(Task.fromJson(element));
    });
    return listTasks;
  }

  /// Creating a new task
  /// For the date, we convert yyyy-MM-dd to dd/MM/yyyy
  ///
  /// ### Params
  /// - taskToCreate : The new task to create
  Future<bool> createTask(Task taskToCreate) async {
    try {
      var taskAsJson = taskToCreate.toJson();
      var newDate = '';
      int i = 0;
      (taskAsJson['date_limit'] as String)
          .split('-')
          .reversed
          .forEach((element) {
        ++i;
        newDate += ((i == 2) ? '0' : '') + element + '/';
      });
      taskAsJson['date_limit'] = newDate.substring(0, newDate.length - 1);
      taskAsJson['has_steps'] = (taskAsJson['has_steps'] as bool) ? 1 : 0;
      var result =
          await postUrl(Uri.parse(tasksUrl), jsonEncode(taskAsJson), token);
      var resultAsMap = jsonDecode(result);
      return resultAsMap['message'] as String == 'Task created';
    } on Exception {
      return false;
    }
  }

  /// Get all tasks finished or not
  /// Iterate on the json result to build a list of tasks
  ///
  /// ### Params (optional)
  /// - finished : bool to know if we should retrieve finished tasks or not
  Future<List<Task>> getFinishedTasks([bool finished = true]) async {
    var uri = Uri.parse(tasksUrl + (finished ? 'finished' : 'unfinished'));
    var results = await getUrl(uri, '', token);
    var jsonContent = jsonDecode(results);
    var listTasks = <Task>[];
    (jsonContent['data'] as List).forEach((element) {
      listTasks.add(Task.fromJson(element));
    });
    return listTasks;
  }

  /// Get all tasks expired (date_limit passed)
  /// Iterate on the json result to build a list of tasks
  Future<List<Task>> getExpiredTasks() async {
    var uri = Uri.parse(tasksUrl + 'expired');
    var results = await getUrl(uri, '', token);
    var jsonContent = jsonDecode(results);
    var listTasks = <Task>[];
    (jsonContent['data'] as List).forEach((element) {
      listTasks.add(Task.fromJson(element));
    });
    return listTasks;
  }

  /// Search tasks by title
  /// Iterate on the json result to build a list of tasks
  ///
  /// ### Params
  /// - title : The title to use for the search
  Future<List<Task>> searchTasks(String title) async {
    var uri = Uri.parse(tasksUrl + 'search/$title');
    var results = await getUrl(uri, '', token);
    var jsonContent = jsonDecode(results);
    var listTasks = <Task>[];
    (jsonContent['data'] as List).forEach((element) {
      listTasks.add(Task.fromJson(element));
    });
    return listTasks;
  }

  /// Get a specific task with its slug
  ///
  /// ### Params
  /// - slug : The slug for the research
  Future<Task> getTask(String slug) async {
    var taskAsJson = await getUrl(Uri.parse(tasksUrl + slug), '', token);
    var task = Task.fromJson(jsonDecode(taskAsJson));
    return task;
  }

  /// Update a specific task
  ///
  /// ### Params
  /// - slug : The slug of the task to update
  /// - taskNewValue : The new task value
  Future<bool> updateTask(String slug, Task taskNewValue) async {
    try {
      var taskAsJson = taskNewValue.toJson();
      var newDate = '';
      int i = 0;
      (taskAsJson['date_limit'] as String)
          .split('-')
          .reversed
          .forEach((element) {
        ++i;
        newDate += ((i == 2) ? '0' : '') + element + '/';
      });
      taskAsJson['date_limit'] = newDate.substring(0, newDate.length - 1);
      taskAsJson['has_steps'] = (taskAsJson['has_steps'] as bool) ? 1 : 0;
      var resultOfUpdate = await putUrl(
          Uri.parse(tasksUrl + slug), jsonEncode(taskAsJson), token);
      return jsonDecode(resultOfUpdate)['message'] as String == 'Task updated';
    } on Exception {
      return false;
    }
  }

  /// Mark a task as finished or not
  ///
  /// ### Params
  /// - slug : The slug of the task which status is going to be updated
  /// - finishOrNot : The status to set
  Future<bool> finishTask(String slug, bool finishOrNot) async {
    try {
      var data = <String, int>{'status': (finishOrNot ? 1 : 0)};
      var resultOfMarkingFinished =
          await putUrl(Uri.parse(tasksUrl + slug), jsonEncode(data), token);
      return jsonDecode(resultOfMarkingFinished)['message'] ==
          'Task status updated';
    } on Exception {
      return false;
    }
  }

  /// Delete a specific task
  ///
  /// ### Params
  /// - slug : The slug of the task to delete
  Future<bool> deleteTask(String slug) async {
    try {
      var resultOfDelete =
          await deleteUrl((Uri.parse(tasksUrl + slug)), '', token);
      return jsonDecode(resultOfDelete)['message'] as String == 'Task deleted';
    } on Exception {
      return false;
    }
  }
}
