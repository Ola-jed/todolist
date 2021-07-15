import 'package:test/test.dart';
import 'package:todolist/api/auth_service.dart';

// Don't forget to flush the database to avoid insert errors
// Or to change the default values
void main() {
  final authService = AuthService();
  final testEmail = 'ola@yahoo.bj';
  group('Auth test', () async{
    test('Signup', () async{
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
    test('Signin ', () async{
      final signinData = <String, String>{
        'email': testEmail,
        'password': '0000',
        'device_name': testEmail
      };
      final value = await authService.makeSignin(signinData);
      expect(value, () {
        allOf([isNotEmpty]);
      });
    });
  });
}
