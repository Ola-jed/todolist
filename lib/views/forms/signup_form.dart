import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/api/token_handler.dart';

/// Our signup form
class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  var data = Map();
  final emailRegex = RegExp(r"[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+");

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
            Center(child: const Image(image: AssetImage('assets/icon.png'))),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                onSaved: (value) => data['name'] = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.account_circle_outlined),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return 'The name field is required';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email)),
                onSaved: (value) => data['email'] = value,
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return 'The email field is required';
                  }
                  if (!emailRegex.hasMatch(value!)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                onSaved: (value) {
                  data['password1'] = value;
                  data['password2'] = value;
                },
                obscureText: _isObscure,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  labelText: 'Password',
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
                    return 'The password field is required';
                  }
                  return null;
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  side: BorderSide(color: Colors.black, width: 1),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      await storeToken(await AuthService().makeSignup(data));
                      Navigator.pushNamed(context, '/');
                    } on Exception {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Signup failed'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Sign up'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: const Text('Already registered ? Sign in'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
