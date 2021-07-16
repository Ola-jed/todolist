import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todolist/models/task.dart';

/// Get the local path of the application
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

/// Get the todolist.csv file
Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/todolist.csv');
}

/// Save a task list into a csv file
///
/// ### Params
/// - taskList : The list containing the tasks to save
Future<File> saveTasksToCsv(List<Task> tasksList) async {
  final file = await _localFile;
  var data = 'Title;Priority;Date limit;Finished';
  tasksList
      .map((e) => '${e.title};${e.priority};${e.dateLimit};${e.isFinished}')
      .forEach((element) {
    data += element + '\n';
  });
  return file.writeAsString(data);
}
