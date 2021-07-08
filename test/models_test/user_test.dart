import 'package:test/test.dart';
import 'package:todolist/models/user.dart';

void main() {
  group('User model tests', () {
    test('Basic constructor', () {
      var usr = User('Ola-jed', 'olabijed@gmail.com');
      expect(usr.name, 'Ola-jed');
      expect(usr.email, 'olabijed@gmail.com');
      var otherUsr = User('John Doe', 'johndoe@hotmail.com');
      expect(otherUsr.name, 'John Doe');
      expect(otherUsr.email, 'johndoe@hotmail.com');
    });
    test('Serialization', () {
      var usr = User('Ola-jed', 'olabijed@gmail.com');
      var serialized = usr.toJson();
      expect(serialized['name'], 'Ola-jed');
      expect(serialized['email'], 'olabijed@gmail.com');
      var map = <String, dynamic>{
        'name': 'Ola-jed',
        'email': 'olabijed@gmail.com'
      };
      expect(usr.toJson(), map);
    });
    test('Deserialization', () {
      var map = <String, dynamic>{
        'name': 'Ola-jed',
        'email': 'olabijed@gmail.com'
      };
      var usr = User.fromJson(map);
      expect(usr.name, 'Ola-jed');
      expect(usr.email, 'olabijed@gmail.com');
    });
  });
}
