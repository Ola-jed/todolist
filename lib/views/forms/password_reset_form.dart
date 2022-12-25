import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/utils/todolist_theme.dart';

/// Our signin form
class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({Key? key}) : super(key: key);

  @override
  _PasswordResetFormState createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  var data = Map();
  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+");
  bool _loading = false;

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
              child: Text(
                $(context).passwordReset,
                style: const TextStyle(
                  fontSize: 17,
                ),
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
                  hintText: $(context).enterEmail,
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
            Center(
              child: ElevatedButton(
                style: TodolistTheme.primaryBtn(),
                onPressed: _loading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => _loading = true);
                          try {
                            // TODO : Fix the issue with the snackbars not showing
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text($(context).resetPassword),
                                  content: Text(
                                    $(context).resetPasswordQuestion,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        final hasReset = await AuthService()
                                            .resetPassword(data);
                                        if (hasReset) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                $(context).emailSentToYou,
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                $(context).anErrorOccurred,
                                              ),
                                            ),
                                          );
                                        }
                                        Navigator.pop(context, true);
                                      },
                                      child: Text($(context).yes),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: Text($(context).no),
                                    ),
                                  ],
                                );
                              },
                            );
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text($(context).anErrorOccurred),
                              ),
                            );
                          } finally {
                            setState(() => _loading = false);
                          }
                        }
                      },
                child: _loading
                    ? CircularProgressIndicator()
                    : Text($(context).resetPassword),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: TextButton(
                  style: TodolistTheme.secondaryBtn(context),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text($(context).notYetRegistered),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
