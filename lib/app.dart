import 'package:flutter/material.dart';
import 'package:todolist/views/screens/account_screen.dart';
import 'package:todolist/views/screens/auth_screen.dart';
import 'package:todolist/views/screens/home_screen.dart';
import 'package:todolist/views/screens/password_reset_screen.dart';

MaterialApp app() {
  return MaterialApp(
    title: 'TodoList',
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.teal
    ),
    initialRoute: '/signin',
    routes: {
      '/signup': (context) => AuthScreen(authType: AuthType.Signup),
      '/signin': (context) => AuthScreen(authType: AuthType.Signin),
      '/account': (context) => AccountScreen(),
      '/forgotten-password': (context) => PasswordResetScreen(),
      '/' : (context) => HomeScreen()
    },
    debugShowCheckedModeBanner: false
  );
}