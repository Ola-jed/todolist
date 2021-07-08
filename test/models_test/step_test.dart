import 'package:test/test.dart';
import 'package:todolist/models/step.dart';

void main() {
  group('Step model tests', () {
    test('Constructor', () {
      var stp = Step('Test', 1);
      expect(stp.title, 'Test');
      expect(stp.priority, 1);
      expect(stp.isFinished, false);
      var otherStp = Step('Other', 8, true);
      expect(otherStp.title, 'Other');
      expect(otherStp.priority, 8);
      expect(otherStp.isFinished, true);
    });
    test('Serialization', () {
      var stp = Step('Test', 2);
      var serialized = stp.toJson();
      expect(serialized['title'], 'Test');
      expect(serialized['priority'], 2);
      expect(serialized['is_finished'], false);
      var map = <String, dynamic>{
        'title': 'Test',
        'priority': 2,
        'is_finished': false
      };
      expect(serialized, map);
    });
    test('Deserialization', () {
      var map = <String, dynamic>{
        'title': 'A step',
        'priority': 4,
        'is_finished': true
      };
      var stp = Step.fromJson(map);
      expect(stp.title, 'A step');
      expect(stp.priority, 4);
      expect(stp.isFinished, true);
    });
  });
}
