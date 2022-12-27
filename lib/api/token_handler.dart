import 'package:shared_preferences/shared_preferences.dart';

/// Function to store the token in local preferences
///
/// ### Param
/// - token : A string representation of the token
Future<void> storeToken(String token) async {
  final preferences = await SharedPreferences.getInstance();
  preferences.setString('token', token);
  StaticTokenStore.storeToken(token);
}

/// Get the stored token
/// If no token exists, returns an empty String
Future<String> getToken() async {
  var token = StaticTokenStore.getToken();
  if (token == null) {
    final preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    StaticTokenStore.storeToken(token);
  }
  
  return token ?? '';
}

/// Delete the stored token
Future<void> removeToken() async {
  final preferences = await SharedPreferences.getInstance();
  await preferences.remove('token');
  StaticTokenStore.removeToken();
}

/// Utility class to store the token with an application lifetime
/// to avoid hitting the shared preferences everytime we want
/// to fetch the api token
class StaticTokenStore {
  static String? _token;

  StaticTokenStore._();

  static void storeToken(String? token) => _token = token;

  static String? getToken() => _token;

  static void removeToken() => _token = null;
}
