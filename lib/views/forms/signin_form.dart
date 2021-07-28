import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/api/token_handler.dart';

/// Our signin form
class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  var data = Map();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

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
              child: const Image(
                image: AssetImage('assets/icon.png')
              )
            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) => data['email'] = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Email',
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
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              child: TextFormField(
                obscureText: _isObscure,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) => data['password'] = value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off)
                  )
                ),
                validator: (value) {
                  if(value == null || value.trim().isEmpty){
                    return 'The password field is required';
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
                  side: BorderSide(color: Colors.black, width: 1)
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try{
                      await storeToken(await AuthService().makeSignin(data));
                      Navigator.pushNamed(context, '/');
                    }
                    on Exception{
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                          content: const Text('Signin failed')
                      ));
                    }
                  }
                },
                child: const Text('Sign in')
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
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/forgotten-password');
                },
                child: const Text('Forgotten password ?')
              )
            )
          ]
        )
      )
    );
  }
}
