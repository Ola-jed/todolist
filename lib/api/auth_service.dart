import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/api/api_base.dart';
import 'package:todolist/api/exceptions/response_retrieving_exception.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Service that calls backend for auth management
class AuthService extends ApiBase {
  static final String signupUrl = ApiBase.apiUrl + 'signup';
  static final String signinUrl = ApiBase.apiUrl + 'signin';
  static final String logoutUrl = ApiBase.apiUrl + 'logout';
  static final String passwordResetUrl = ApiBase.apiUrl + 'password-reset';
  static final String tokenCheckUrl = ApiBase.apiUrl + 'token-check';

  /// Handle the signup
  /// Call api with data and return token if the process completed successfully
  ///
  /// ### Param
  /// - signupData : The serialized data with email name and password
  Future<String> makeSignup(Map signupData) async {
    try {
      signupData['device_name'] = await _getDeviceIdentity();
      print(signupData);
      final result = await postUrl(
        Uri.parse(signupUrl),
        json.encode(signupData),
      );
      final jsonResult = json.decode(result) as Map<String, dynamic>;
      if (jsonResult['token'] == null) throw Exception('Signup failed');
      return jsonResult['token']!;
    } on Exception catch (e) {
      throw ResponseRetrievingException('$e');
    }
  }

  /// Handle the signin for users
  /// Returns the token if available
  ///
  /// ### Param
  /// - signinData : The serialized data with email and password
  Future<String> makeSignin(Map signinData) async {
    try {
      signinData['device_name'] = await _getDeviceIdentity();
      final result = await postUrl(
        Uri.parse(signinUrl),
        json.encode(signinData),
      );
      final jsonResult = json.decode(result) as Map<String, dynamic>;
      if (jsonResult['token'] == null) throw Exception('Signin failed');
      return jsonResult['token']!;
    } on Exception catch (e) {
      throw ResponseRetrievingException('$e');
    }
  }

  /// Logout the user
  /// We remove the token from local preferences
  ///
  /// ### Param
  /// - token : The token granted to the user who wants to logout himself
  Future<bool> makeLogout(String token) async {
    try {
      final result = await postUrl(Uri.parse(logoutUrl), '', token);
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      return (jsonDecode(result)['message'] as String) == 'Logout successful';
    } on Exception {
      return false;
    }
  }

  /// Start the password reset process
  ///
  /// ### Param
  /// - email : The email to where we should send the email
  Future<bool> resetPassword(Map passwordResetData) async {
    try {
      final result = await postUrl(
        Uri.parse(passwordResetUrl),
        json.encode(passwordResetData),
      );
      return (jsonDecode(result)['message'] as String) == 'Password reset';
    } on Exception {
      return false;
    }
  }

  /// Method to check if the given token is correct
  ///
  /// ### Param
  /// - token : The token we want to check
  Future<bool> checkToken(String token) async {
    try {
      final result = await getUrl(Uri.parse(tokenCheckUrl), '', token);
      return (jsonDecode(result)['authenticated'] as bool);
    } on Exception {
      return false;
    }
  }

  /// Get the device identity for auth requests
  Future<String> _getDeviceIdentity() async {
    final info = await DeviceInfoPlugin().androidInfo;
    return '${info.device}-${info.id}';
  }
}
