import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/utils/todolist_theme.dart';

/// Our signin form
class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+");
  final data = Map();
  bool _loading = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: const Image(
                image: AssetImage('assets/icon.png'),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) => data['email'] = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: $(context).email,
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return $(context).emailRequired;
                  }
                  if (!emailRegex.hasMatch(value!)) {
                    return $(context).invalidEmailFormat;
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                obscureText: _isObscure,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) => data['password'] = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: $(context).password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return $(context).passwordRequired;
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: ElevatedButton(
                  style: TodolistTheme.primaryBtn(),
                  onPressed: _loading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() => _loading = true);

                            try {
                              await storeToken(
                                await AuthService().makeSignin(data),
                              );
                              Navigator.pushNamed(context, '/');
                            } on Exception {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text($(context).signinFailed),
                                ),
                              );
                            } finally {
                              setState(() => _loading = false);
                            }
                          }
                        },
                  child: _loading
                      ? CircularProgressIndicator()
                      : Text($(context).signin),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: TextButton(
                  style: TodolistTheme.secondaryBtn(context),
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: Text($(context).notYetRegistered),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: TextButton(
                  style: TodolistTheme.secondaryBtn(context),
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgotten-password');
                  },
                  child: Text($(context).forgottenPassword),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
