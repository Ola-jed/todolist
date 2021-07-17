import 'package:shared_preferences/shared_preferences.dart';

/// Function to store the token in local preferences
///
/// ### Param
/// - token : A string representation of the token
Future<void> storeToken(String token) async {
  final preferences = await SharedPreferences.getInstance();
  preferences.setString('token', token);
}

/// Get the stored token
/// If no token exists, returns an empty String
Future<String> getToken() async {
  final preferences = await SharedPreferences.getInstance();
  return preferences.getString('token') ?? ' ';
}

/// Delete the stored token
Future<void> removeToken() async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.remove('token');
}
