import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:todolist/views/screens/account_screen.dart';
import 'package:todolist/views/screens/auth_screen.dart';
import 'package:todolist/views/screens/home_screen.dart';
import 'package:todolist/views/screens/password_reset_screen.dart';

/// Build the application
/// If we have a valid token in the storage, we redirect to the home screen
/// Otherwise, we redirect to signin screen
Widget app(bool hasValidToken) {
  return ConnectionNotifier(
    child: MaterialApp(
      title: 'TodoList',
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.teal),
      initialRoute: hasValidToken ? '/' : '/signin',
      routes: {
        '/signup': (context) => AuthScreen(authType: AuthType.Signup),
        '/signin': (context) => AuthScreen(authType: AuthType.Signin),
        '/account': (context) => AccountScreen(),
        '/forgotten-password': (context) => PasswordResetScreen(),
        '/': (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    ),
    disconnectedContent: Container(
      child: Text("This application require internet connection to work"),
    ),
  );
}
