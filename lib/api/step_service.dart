import 'dart:convert' show jsonEncode, jsonDecode;
import 'package:todolist/api/api_base.dart';
import 'package:todolist/models/step.dart';
import 'package:todolist/api/task_service.dart';

/// Service that calls backend for steps management
class StepService extends ApiBase {
  static final stepsUrl = ApiBase.apiUrl + 'steps/';

  /// Call the api to get all the steps related to a task
  /// Iterate on the json result to build a list of steps
  ///
  /// ### Params
  /// - taskSlug : slug of the task
  Future<List> getStepsFromTask(String taskSlug) async {
    final results = await get(
      Uri.parse(TaskService.tasksUrl + '/' + taskSlug + '/steps'),
    );
    return ((jsonDecode(results))['data'] as List)
        .map((e) => Step.fromJson(e))
        .toList();
  }

  /// Creating a new step for a task
  ///
  /// ### Params
  /// - taskSlug : The slug of the task which the step belongs to
  /// - stepToCreate : The new task to create
  Future<bool> createStep(String taskSlug, Step stepToCreate) async {
    try {
      final result = await post(
        Uri.parse(TaskService.tasksUrl + '/' + taskSlug + '/steps'),
        data: jsonEncode(stepToCreate.toJson()),
      );
      final resultAsMap = jsonDecode(result);
      return resultAsMap['message'] as String == 'Step created';
    } on Exception {
      return false;
    }
  }

  /// Get a specific step with its id
  ///
  /// ### Params
  /// - stepId : The id of the searched step
  Future<Step> getStep(int stepId) async {
    final taskAsJson = await get(
      Uri.parse(stepsUrl + stepId.toString()),
    );
    return Step.fromJson(jsonDecode(taskAsJson));
  }

  /// Update a specific step
  ///
  /// ### Params
  /// - stepId : The id of the step to update
  /// - stepNewValue : The new value of the step
  Future<bool> updateStep(int stepId, Step stepNewValue) async {
    try {
      final resultOfUpdate = await put(
        Uri.parse(stepsUrl + stepId.toString()),
        data: jsonEncode(stepNewValue.toJson()),
      );
      return jsonDecode(resultOfUpdate)['message'] as String == 'Step updated';
    } on Exception {
      return false;
    }
  }

  /// Mark a step as finished or not
  ///
  /// ### Params
  /// - stepId : The id of the step
  /// - finishOrNot : The status to set
  Future<bool> finishStep(int stepId, bool finishOrNot) async {
    try {
      final data = <String, int>{'status': (finishOrNot ? 1 : 0)};
      final resultOfMarkingFinished = await put(
        Uri.parse(stepsUrl + stepId.toString() + '/finish'),
        data: jsonEncode(data),
      );
      return jsonDecode(resultOfMarkingFinished)['message'] == ('Step ' + (finishOrNot ? 'finished' : 'unfinished'));
    } on Exception {
      return false;
    }
  }

  /// Delete a specific step
  ///
  /// ### Params
  /// - stepId : The id of the step to delete
  Future<bool> deleteStep(int stepId) async {
    try {
      final resultOfDelete = await delete(
        Uri.parse(stepsUrl + stepId.toString()),
      );
      return jsonDecode(resultOfDelete)['message'] as String == 'Step deleted';
    } on Exception {
      return false;
    }
  }
}
