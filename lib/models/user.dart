import 'package:todolist/models/serializable.dart';

/// Users of todolist
class User extends Serializable {
  String name;
  String email;

  User(this.name, this.email);

  @override
  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String;

  @override
  Map<String, dynamic> toJson() => {'name': name, 'email': email};
}