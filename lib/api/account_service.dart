import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/api/api_base.dart';
import 'package:todolist/api/exceptions/response_retrieving_exception.dart';
import 'package:todolist/models/user.dart';

/// Service that calls backend for account management
class AccountService extends ApiBase {
  static final String accountUrl = ApiBase.apiUrl + 'account';

  /// Handle the signup
  /// Call api with data and return the authenticated user
  Future<User> getAccountInfo() async {
    try {
      final result = await get(Uri.parse(accountUrl));
      final jsonResult = json.decode(result) as Map<String, dynamic>;
      return User.fromJson(jsonResult);
    } on Exception catch (e) {
      throw ResponseRetrievingException('$e');
    }
  }

  /// Handle the account update
  ///
  /// ### Params
  /// - userData : The serialized data with name email and password
  Future<bool> updateAccount(Map userData) async {
    try {
      await put(
        Uri.parse(accountUrl),
        data: json.encode(userData),
      );
      return true;
    } on Exception {
      return false;
    }
  }

  /// Delete the user account
  /// We also remove the token from local preferences
  ///
  /// ### Params
  /// - password : The password of the user
  Future<bool> deleteAccount(String password) async {
    try {
      await delete(
        Uri.parse(accountUrl),
        data: jsonEncode({'password': password}),
      );
      final preferences = await SharedPreferences.getInstance();
      await preferences.remove('token');
      return true;
    } on Exception {
      return false;
    }
  }
}
