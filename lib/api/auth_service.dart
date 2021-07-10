import 'dart:convert';
import 'package:todolist/api/api_base.dart';
import 'package:todolist/api/exceptions/response_retrieving_exception.dart';

/// Service that calls backend for auth management
class AuthService extends ApiBase {
  static final String signupUrl = ApiBase.apiUrl + 'signup';
  static final String signinUrl = ApiBase.apiUrl + 'signin';
  static final String logoutUrl = ApiBase.apiUrl + 'logout';

  /// Handle the signup
  /// Call api with data and return token if the process completed successfully
  ///
  /// ### Params
  /// - signupData : The serialized data with email name and password
  Future<String> makeSignup(Map signupData) async {
    try {
      var result = await postUrl(Uri.parse(signupUrl), json.encode(signupData));
      var jsonResult = json.decode(result) as Map<String, String>;
      if (jsonResult['token'] == null) throw Exception('Signup failed');
      return jsonResult['token']!;
    } catch (e) {
      throw ResponseRetrievingException(e.toString());
    }
  }

  /// Handle the signin for users
  /// Returns the token if available
  ///
  /// ### Params
  /// - signinData : The serialized data with email and password
  Future<String> makeSignin(Map signinData) async {
    try {
      var result = await postUrl(Uri.parse(signinUrl), json.encode(signinData));
      var jsonResult = json.decode(result) as Map<String, String>;
      if (jsonResult['token'] == null) throw Exception('Signin failed');
      return jsonResult['token']!;
    } catch (e) {
      throw ResponseRetrievingException(e.toString());
    }
  }

  /// Logout the user
  ///
  /// ### Params
  /// - token : The token granted to the user who wants to logout himself
  Future<bool> makeLogout(String token) async {
    try {
      postUrl(Uri.parse(logoutUrl), '', token);
      return true;
    } on Exception {
      return false;
    }
  }
}
