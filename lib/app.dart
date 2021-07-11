import 'package:flutter/material.dart';
import 'package:todolist/views/screens/auth_screen.dart';

MaterialApp app() {
  return MaterialApp(
      title: 'TodoList',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.teal
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => AuthScreen(authType: AuthType.Signup),
        '/signin': (context) => AuthScreen(authType: AuthType.Signin),
        //'/' : (context) => null
      },
      debugShowCheckedModeBanner: false
  );
}