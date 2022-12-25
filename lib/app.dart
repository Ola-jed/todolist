import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todolist/utils/todolist_theme.dart';
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
      theme: TodolistTheme.lightTheme,
      darkTheme: TodolistTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: hasValidToken ? '/' : '/signin',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
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
      child: Text('This application require internet connection to work'),
    ),
  );
}
