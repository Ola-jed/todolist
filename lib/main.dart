import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await getToken();
  final hasValidToken = await AuthService().checkToken(token);
  runApp(app(hasValidToken));
}