import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';

/// Our signin form
class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({Key? key}) : super(key: key);

  @override
  _PasswordResetFormState createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  var data = Map();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: const Text(
                'Password reset',
                style: const TextStyle(fontSize: 17,)
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) => data['email'] = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email)
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'The email field is required';
                  }
                  if(!RegExp(r"[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+").hasMatch(value)){
                    return 'Invalid email format';
                  }
                  return null;
                }
              )
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.teal,
                  side: const BorderSide(color: Colors.black, width: 1)
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try{
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Reset password'),
                            content: const Text('Do you want to reset your password ?'),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  final hasReset = await AuthService().resetPassword(data);
                                  if(hasReset) {
                                    ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                        content: const Text('An email has been sent to you. Check your emails')
                                    ));
                                  }
                                  else {
                                    ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                        content: const Text('An error occurred during the process')
                                    ));
                                  }
                                  Navigator.pop(context,true);
                                },
                                child: const Text('Yes')
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context,true);
                                },
                                child: const Text('No')
                              )
                            ]
                          );
                        }
                      );
                    }
                    on Exception{
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                          content: Text('Signin failed')
                      ));
                    }
                  }
                },
                child: const Text('Reset password')
              )
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('Not yet registered ? Sign up')
              )
            )
          ]
        )
      )
    );
  }
}
