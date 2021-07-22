import 'package:flutter/material.dart';
import 'package:todolist/views/forms/password_reset_form.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordResetForm()
    );
  }
}