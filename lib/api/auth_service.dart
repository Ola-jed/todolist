import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/api/api_base.dart';
import 'package:todolist/api/exceptions/response_retrieving_exception.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:todolist/api/token_handler.dart';

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
      final result = await post(
        Uri.parse(signupUrl),
        data: json.encode(signupData),
        shouldFetchInternalToken: false,
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
      final result = await post(
        Uri.parse(signinUrl),
        data: json.encode(signinData),
        shouldFetchInternalToken: false,
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
  Future<bool> makeLogout(String token) async {
    try {
      final result = await post(Uri.parse(logoutUrl));
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      StaticTokenStore.removeToken();
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
      final result = await post(
        Uri.parse(passwordResetUrl),
        data: json.encode(passwordResetData),
        shouldFetchInternalToken: false,
      );
      return (jsonDecode(result)['message'] as String) == 'Password reset';
    } on Exception {
      return false;
    }
  }

  /// Method to check if the given token is correct
  Future<bool> checkToken() async {
    try {
      final result = await get(Uri.parse(tokenCheckUrl));
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
