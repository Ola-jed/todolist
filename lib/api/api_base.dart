import 'dart:io';
import 'dart:convert' show jsonDecode, utf8;

import 'package:todolist/api/exceptions/api_connection_exception.dart';

/// HTTP verbs
enum HTTP_METHOD { GET, PUT, POST, DELETE }

/// Abstract class that allows us to make our api calls
abstract class ApiBase {
  static String apiUrl = 'http://localhost:8000/api/';
  static String token = '';

  /// Our base function for api calls
  ///
  /// ### Params
  /// - uri : The uri to call
  /// - httpMethod : The http verb
  ///
  /// ### Optional params
  ///
  /// - token : The token for api authentication
  /// - data :  The json data to pass to the api
  Future<String> contactUrl(Uri uri, HTTP_METHOD httpMethod,
      [String data = '', String token = '']) async {
    var httpClient = HttpClient();
    try {
      var request = (httpMethod == HTTP_METHOD.GET)
          ? await httpClient.getUrl(uri)
          : (httpMethod == HTTP_METHOD.POST)
              ? await httpClient.postUrl(uri)
              : (httpMethod == HTTP_METHOD.PUT)
                  ? await httpClient.putUrl(uri)
                  : await httpClient.deleteUrl(uri);
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.headers.add("Authorization", token);
      request.write(data);
      HttpClientResponse response = await request.close();
      var responseContent = await response.transform(utf8.decoder).join("");
      return responseContent;
    } catch (e) {
      throw ApiConnectionException(e.toString());
    }
  }

  /// Base function for http get requests
  Future<String> getUrl(Uri uri, [String data = '', String token = '']) async {
    return contactUrl(uri, HTTP_METHOD.GET, data, token);
  }

  /// Base function for http post requests
  Future<String> postUrl(Uri uri, [String data = '', String token = '']) async {
    return contactUrl(uri, HTTP_METHOD.POST, data, token);
  }

  /// Base function for http put requests
  Future<String> putUrl(Uri uri, [String data = '', String token = '']) async {
    return contactUrl(uri, HTTP_METHOD.PUT, data, token);
  }

  /// Base function for http delete requests
  Future<String> deleteUrl(Uri uri,
      [String data = '', String token = '']) async {
    return contactUrl(uri, HTTP_METHOD.DELETE, data, token);
  }
}
