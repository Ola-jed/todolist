import 'package:flutter/material.dart';
import 'package:todolist/views/screens/auth_screen.dart';
import 'package:todolist/views/screens/home_screen.dart';

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
      '/' : (context) => HomeScreen()
    },
    debugShowCheckedModeBanner: false
  );
}