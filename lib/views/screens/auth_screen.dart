import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todolist/views/forms/signin_form.dart';
import 'package:todolist/views/forms/signup_form.dart';

enum AuthType { Signup, Signin }

/// Auth screen for signup and signin
/// We don't want to go back when we are on this screen
class AuthScreen extends StatelessWidget {
  final authType;
  const AuthScreen({@required this.authType,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: authType == AuthType.Signin ? SigninForm() : SignupForm()
      ),
      onWillPop: () async {
        await SystemNavigator.pop();
        return false;
      }
    );
  }
}
