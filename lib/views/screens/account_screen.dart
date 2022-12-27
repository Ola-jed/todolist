import 'package:flutter/material.dart';
import 'package:todolist/api/account_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/models/user.dart';
import 'package:todolist/utils/l10n.dart';
import 'package:todolist/utils/todolist_theme.dart';
import 'package:todolist/views/ui/bottom_menubar.dart';
import 'package:todolist/views/ui/routes.dart';

/// Account screen
class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;
  bool _passwordIsObscure = true;
  bool _newPasswordIsObscure = true;
  bool _dangerZoneVisible = false;
  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+");
  var data = Map();
  final _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    if (user == null) {
      _getConnectedUser();
    }
  }

  /// Get the authenticated user
  Future<void> _getConnectedUser() async {
    final apiUser = await _accountService.getAccountInfo();
    setState(() => user = apiUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: user == null
            ? Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.45,
                ),
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.only(top: 35, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: const Image(
                          image: AssetImage('assets/avatar.png'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          onSaved: (value) => data['name'] = value,
                          initialValue: user!.name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.account_circle_outlined,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return $(context).nameRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: user!.email,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          onSaved: (value) => data['email'] = value,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return $(context).emailRequired;
                            }
                            if (!emailRegex.hasMatch(value)) {
                              return $(context).invalidEmailFormat;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          onSaved: (value) {
                            data['password'] = value;
                          },
                          obscureText: _passwordIsObscure,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: $(context).enterPassword,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() =>
                                    _passwordIsObscure = !_passwordIsObscure);
                              },
                              icon: Icon(_passwordIsObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return $(context).passwordRequired;
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: TextFormField(
                          onSaved: (value) {
                            data['new_password'] = value;
                          },
                          obscureText: _newPasswordIsObscure,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: $(context).newPassword,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => _newPasswordIsObscure =
                                    !_newPasswordIsObscure);
                              },
                              icon: Icon(_newPasswordIsObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.error,
                        thickness: 4,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: ElevatedButton.icon(
                          icon: Icon(
                            _dangerZoneVisible
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                          ),
                          onPressed: () => setState(
                              () => _dangerZoneVisible = !_dangerZoneVisible),
                          label: Text(
                            $(context).dangerZone,
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _dangerZoneVisible,
                        child: Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.update),
                            style: TodolistTheme.primaryBtn(),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text($(context).updateAccount),
                                      content: Text(
                                        $(context).updateAccountQuestion,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              final hasUpdated =
                                                  await _accountService
                                                      .updateAccount(data);
                                              if (hasUpdated) {
                                                setState(
                                                  () => user = User(
                                                    data['name'],
                                                    data['email'],
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      $(context)
                                                          .accountUpdateFailed,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } on Exception {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    $(context)
                                                        .accountUpdateFailed,
                                                  ),
                                                ),
                                              );
                                            } finally {
                                              Navigator.pop(
                                                context,
                                                true,
                                              );
                                            }
                                          },
                                          child: Text($(context).yes),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                              true,
                                            );
                                          },
                                          child: Text($(context).no),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            label: Text($(context).updateAccountDeclarative),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _dangerZoneVisible,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                          ),
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text($(context).deleteAccount),
                                    content: Text(
                                      $(context).deleteAccountQuestion,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          _formKey.currentState!.save();
                                          var hasDeleted = await _accountService
                                              .deleteAccount(data['password']);
                                          if (hasDeleted) {
                                            await removeToken();
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                              Routes.signup,
                                              (Route<dynamic> route) => false,
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  $(context)
                                                      .accountDeletionFailed,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text($(context).yes),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                            context,
                                            true,
                                          );
                                        },
                                        child: Text($(context).no),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_forever),
                            label: Text(
                              $(context).deleteAccountDeclarative,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onError,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: BottomMenuBar(currentIndex: 1),
    );
  }
}
