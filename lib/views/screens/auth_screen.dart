import 'package:flutter/material.dart';
import 'package:todolist/views/forms/signin_form.dart';
import 'package:todolist/views/forms/signup_form.dart';

enum AuthType { Signup, Signin }

class AuthScreen extends StatelessWidget {
  final authType;
  const AuthScreen({@required this.authType,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: authType == AuthType.Signin ? SigninForm() : SignupForm()
    );
  }
}
