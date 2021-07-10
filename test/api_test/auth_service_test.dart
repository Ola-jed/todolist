import 'package:test/test.dart';
import 'package:todolist/api/auth_service.dart';

void main() {
  group('Auth service test', () {
    test('Signup', () {
      var signupData = <String, String>{
        'name': 'Test user',
        'email': 'test@yahoo.com',
        'password1': '0000',
        'password2': '0000',
        'device_name': 'Test user'
      };
      var authService = AuthService();
      authService.makeSignup(signupData).then((value) {
        print(value);
      }).onError((error, stackTrace) {
        print('Error : $error');
      });
    });
    test('Signin', () {

    });
  });
}
