/// Here we have the functions to encapsulate token storage
import 'package:shared_preferences/shared_preferences.dart';

/// Function to store the token in local preferences
///
/// ### Param
/// - token : A string representation of the token
Future<void> storeToken(String token) async {
  var preferences = await SharedPreferences.getInstance();
  preferences.setString('token', token);
}

/// Get the stored token
/// If no token exists, returns an empty String
Future<String> getToken() async {
  var preferences = await SharedPreferences.getInstance();
  return preferences.getString('token') ?? ' ';
}