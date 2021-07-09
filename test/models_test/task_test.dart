import 'package:slugify/slugify.dart';
import 'package:test/test.dart';
import 'package:todolist/models/task.dart';

void main(){
  group('Task model tests',()  {
    test('Constructor',(){
      var tsk = Task('Task', slugify('Task'), false, 'description', DateTime.now(), 4, false);
      expect(tsk.title,'Task');
      expect(tsk.slug,'task');
      expect(tsk.hasSteps,false);
      expect(tsk.priority,4);
    });
  });
}