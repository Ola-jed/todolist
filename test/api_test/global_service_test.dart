import 'package:test/test.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/models/task.dart';

/// Test for auth and task management
void main() {
  var authService = AuthService();
  final testEmail = 'johndoe@outlook.com';
  group('Services test', () {
    test('Signup', () async {
      final signupData = <String, String>{
        'name': 'Test user',
        'email': testEmail,
        'password1': '0000',
        'password2': '0000',
        'device_name': 'Test user'
      };
      final value = await authService.makeSignup(signupData);
      expect(value, () {
        allOf([isNotEmpty]);
      });
    });
    test('Signin and tasks testing', () {
      final signinData = <String, String>{
        'email': testEmail,
        'password': '0000',
        'device_name': testEmail
      };
      authService.makeSignin(signinData).then((value) {
        expect(value, () {
          allOf([isNotEmpty]);
        }); // Token should not be empty
        var taskService = TaskService();
        taskService.getTasks().then((value) {
          expect(value, () {
            allOf([isEmpty]);
          }); // No task yet created
          var task = Task(
            'title',
            'title',
            false,
            'description',
            DateTime.now(),
            2,
          );
          taskService.createTask(task).then((val) {
            expect(true, val);
            taskService.getTasks().then((tasks) {
              expect(1, tasks.length);
              taskService.deleteTask(task.slug).then((deleted) {
                expect(true, deleted);
              }).onError((error, stackTrace) {
                fail(error.toString());
              }); // Delete should succeed
            }).onError((error, stackTrace) {
              fail(error.toString());
            }); // Only one task created
          }).onError((error, stackTrace) {
            fail(error.toString());
          }); // The creation should succeed
        }).onError((error, stackTrace) {
          fail(error.toString());
        });
      }).onError((error, stackTrace) {
        fail(error.toString());
      });
    });
  });
}
