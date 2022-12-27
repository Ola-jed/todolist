import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasValidToken = await AuthService().checkToken();
  runApp(app(hasValidToken));
}