import 'package:slugify/slugify.dart';
import 'package:test/test.dart';
import 'package:todolist/models/task.dart';

void main() {
  group('Task model tests', () {
    test('Constructor', () {
      var tsk = Task('Task', slugify('Task'), false, 'description',
          DateTime.now(), 4, false);
      expect('Task', tsk.title);
      expect('task', tsk.slug);
      expect('description', tsk.description);
      expect(false, tsk.hasSteps);
      expect(4, tsk.priority);
    });
    test('Serialization', () {
      var date = DateTime.now();
      var tsk =
          Task('Task', slugify('Task'), false, 'description', date, 4, false);
      var map = <String, dynamic>{
        'title': 'Task',
        'description': 'description',
        'has_steps': false,
        'date_limit': '${date.year}-${date.month}-${date.day}',
        'priority': 4
      };
      expect(map, tsk.toJson());
    });
    test('Deserialization', () {
      var map = <String, dynamic>{
        "title": "zedrf",
        "slug": "zedrf",
        "has_steps": true,
        "description": "azas",
        "date_limit": "2021-06-14",
        "is_finished": false,
        "priority": 1
      };
      var task = Task.fromJson(map);
      expect("zedrf", task.title);
      expect("zedrf", task.slug);
      expect(true, task.hasSteps);
      expect('azas', task.description);
      expect(DateTime.parse('2021-06-14'), task.dateLimit);
      expect(1, task.priority);
      expect(true, task.hasSteps);
    });
  });
}
