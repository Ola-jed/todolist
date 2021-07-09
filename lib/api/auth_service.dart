import 'dart:io';

import 'package:todolist/api/api_base.dart';
import 'package:todolist/api/exceptions/api_connection_exception.dart';
import 'package:todolist/models/user.dart';

class AuthService extends ApiBase{
  static String signupUrl = ApiBase.apiUrl+'signup';
  static String signinUrl = ApiBase.apiUrl+'signin';

  String makeSignup(User newUser) {
    // var client = new HttpClient();
    // client.postUrl(Uri.parse(signupUrl))
    // .then((request) {
    //   request.headers.contentType = new ContentType("application", "json", charset: "utf-8");
    //   request.write(newUser.toJson());
    //   var responseFuture = request.close();
    //   responseFuture.then((response){
    //     return response.join().then((value) {
    //       return value;
    //     })
    //   })
    //   .onError((error, stackTrace) {
    //     throw new ApiConnectionException(error.toString());
    //   });
    // })
    // .onError((error, stackTrace) {
    //   throw new ApiConnectionException(error.toString());
    // });
    return '';
  }

}