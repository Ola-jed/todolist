import 'package:flutter/material.dart';
import 'package:todolist/api/account_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/user.dart';

/// Account screen
class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _passwordIsObscure = true;
  bool _newPasswordIsObscure = true;
  bool _dangerZoneVisible = false;
  final _formKey = GlobalKey<FormState>();
  var data = Map();

  /// Get the authenticated user
  Future<User> _getConnectedUser() async{
    final token = await getToken();
    final user = await AccountService(token).getAccountInfo();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          }
        )
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: _getConnectedUser(),
            builder: (context,snapshot) {
              if(snapshot.hasData) {
                var usr = (snapshot.data as User);
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
                            image: AssetImage('assets/avatar.png')
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: TextFormField(
                            onSaved: (value) => data['name'] = value,
                            initialValue: usr.name,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              prefixIcon: const Icon(Icons.account_circle_outlined)
                            ),
                            validator: (value) {
                              if(value == null || value.trim().isEmpty){
                                return 'The name field is required';
                              }
                              return null;
                            }
                          )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            initialValue: usr.email,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              prefixIcon: const Icon(Icons.email)
                            ),
                            onSaved: (value) => data['email'] = value,
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
                            onSaved: (value) {
                              data['password'] = value;
                            },
                            obscureText: _passwordIsObscure,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() => _passwordIsObscure = !_passwordIsObscure);
                                },
                                icon: Icon(_passwordIsObscure ? Icons.visibility : Icons.visibility_off)
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
                        Container(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: TextFormField(
                            onSaved: (value) {
                              data['new_password'] = value;
                            },
                            obscureText: _newPasswordIsObscure,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              hintText: 'New password (facultative)',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() => _newPasswordIsObscure = !_newPasswordIsObscure);
                                },
                                icon: Icon(_newPasswordIsObscure ? Icons.visibility : Icons.visibility_off)
                              )
                            ),
                            validator: (value) {
                              return null;
                            }
                          )
                        ),
                        Divider(
                          color: Colors.redAccent,
                          thickness: 4
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.arrow_drop_down,),
                            onPressed: () => setState(() {_dangerZoneVisible = !_dangerZoneVisible;}),
                            label: Text(
                              'Danger zone',
                              style: TextStyle(fontSize: 18,color: Colors.red)
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent
                            )
                          )
                        ),
                        Visibility(
                          visible: _dangerZoneVisible,
                          child: Container(
                            padding: EdgeInsets.only(top: 5,bottom: 5),
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.update),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Update account ?'),
                                        content: Text('Do you really want to update your account ?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              try{
                                                var token = await getToken();
                                                var hasUpdated = await AccountService(token).updateAccount(data);
                                                if(hasUpdated) {
                                                  // Reload
                                                  Navigator.pushNamed(context, '/account');
                                                }
                                                else{
                                                  ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                      content: const Text('Account update failed'))
                                                  );
                                                }
                                              }
                                              on Exception{
                                                ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                    content: const Text('Account update failed'))
                                                );
                                              }
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
                              },
                              label: const Text('Update account')
                            )
                          )
                        ),
                        Visibility(
                          visible: _dangerZoneVisible,
                          child: Container(
                            padding: EdgeInsets.only(top: 5,bottom: 5),
                            height: 60,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Handle account deletion
                                // Show message box
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Delete account ?'),
                                      content: const Text('Do you really want to delete your account ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            _formKey.currentState!.save();
                                            var token = await getToken();
                                            var hasDeleted = await AccountService(token).deleteAccount(data['password']);
                                            if(hasDeleted) {
                                              await removeToken();
                                              Navigator.of(context)
                                                .pushNamedAndRemoveUntil('/signup', (Route<dynamic> route) => false);
                                            }
                                            else {
                                              ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                  content: Text('Account delete failed'))
                                              );
                                            }
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
                              },
                              icon: const Icon(Icons.delete_forever),
                              label: const Text('Delete account'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red
                              )
                            )
                          )
                        )
                      ]
                    )
                  )
                );
              }
              else if(snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something weird happened ${snapshot.stackTrace.toString()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white,fontSize: 16)
                  )
                );
              }
              else {
                return Center(
                  child: Container(
                    child: CircularProgressIndicator()
                  )
                );
              }
            }
          )
        ]
      )
    );
  }
}