import 'package:test/test.dart';
import 'package:todolist/api/auth_service.dart';

// Don't forget to flush the database to avoid insert errors
void main() {
  var authService = AuthService();
  final testEmail = 'ola@yahoo.bj';
  group('Auth test', () {
    test('Signup', () {
      var signupData = <String, String>{
        'name': 'Test user',
        'email': testEmail,
        'password1': '0000',
        'password2': '0000',
        'device_name': 'Test user'
      };
      authService.makeSignup(signupData).then((value) {
        expect(value, () {
          allOf([isNotEmpty]);
        });
        print(value);
      }).onError((error, stackTrace) {
        fail(error.toString());
      });
    });
    test('Signin ', () {
      var signinData = <String, String>{
        'email': testEmail,
        'password': '0000',
        'device_name': testEmail
      };
      authService.makeSignin(signinData).then((value) {
        expect(value, () {
          allOf([isNotEmpty]);
        });
      }).onError((error, stackTrace) {
        fail(error.toString());
      });
    });
  });
}
