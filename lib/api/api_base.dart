import 'dart:io';
import 'dart:convert' show utf8;
import 'package:todolist/api/exceptions/api_connection_exception.dart';
import 'package:todolist/utils/string_helpers.dart';

/// HTTP verbs
enum HTTP_METHOD { GET, PUT, POST, DELETE }

/// Abstract class that allows us to make our api calls
abstract class ApiBase {
  /// Mapping of the http codes
  static const HTTP_CODES = {
    200: 'OK',
    201: 'Created',
    202: 'Accepted',
    203: 'Non-Authoritative Information',
    204: 'No Content',
    205: 'Reset Content',
    206: 'Partial Content',
    226: 'Im Used',
    300: 'Multiple Choices',
    301: 'Moved Permanently',
    302: 'Temporary Redirect',
    303: 'See Other',
    304: 'Not Modified',
    305: 'Use Proxy',
    307: 'Temporary redirect',
    308: 'Permanent redirect',
    400: 'Bad Request',
    401: 'Unauthorized',
    402: 'Payment Required',
    403: 'Forbidden',
    404: 'Not Found',
    405: 'Method Not Allowed',
    406: 'Not Acceptable',
    407: 'Proxy Authentication Required',
    408: 'Request Time-Out',
    409: 'Conflict',
    410: 'Gone',
    411: 'Length Required',
    412: 'Precondition Failed',
    413: 'Request Entity Too Large',
    414: 'Request-URI Too Large',
    415: 'Unsupported Media Type',
    416: 'Range not satisfiable',
    417: 'Expectation failed',
    422: 'Unprocessable Entity',
    423: 'Locked',
    425: 'Too early',
    426: 'Upgrade required',
    428: 'Precondition required',
    429: 'Too many requests',
    431: 'Request header fields too large',
    451: 'Unavailable for legal reasons',
    500: 'Internal Server Error',
    501: 'Not Implemented',
    502: 'Bad Gateway',
    503: 'Service Unavailable',
    504: 'Gateway Timeout',
    505: 'HTTP Version Not Supported',
    506: 'Variant also negotiates',
    507: 'Insufficient Storage',
    508: 'Loop detected',
    510: 'Not extended',
    511: 'Network authentication required'
  };

  // Local (may change) : http://192.168.43.193:8000/api/
  // Distant : https://todolist-rest-api.herokuapp.com/api/
  static final String apiUrl = 'http://192.168.100.104:8000/api/';
  static String token = '';

  /// Our HttpClient
  final httpClient = HttpClient();

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
  Future<String> callUrl(Uri uri, HTTP_METHOD httpMethod,
      [String data = '', String token = '']) async {
    try {
      print("${httpMethod.name} - ${uri.toString()}");
      print(data);
      var request = (httpMethod == HTTP_METHOD.GET)
          ? await httpClient.getUrl(uri)
          : (httpMethod == HTTP_METHOD.POST)
              ? await httpClient.postUrl(uri)
              : (httpMethod == HTTP_METHOD.PUT)
                  ? await httpClient.putUrl(uri)
                  : await httpClient.deleteUrl(uri);
      request.headers.contentType = ContentType(
        "application",
        "json",
        charset: "utf-8",
      );
      request.headers.add("Accept", "application/json");
      request.headers.add("Authorization", 'Bearer $token');
      if (data.trim().isNotEmpty) {
        request.contentLength = data.length;
      }
      if (!data.isBlank()) {
        request.write(data);
      }
      var response = await request.close();
      final responseContent = await response.transform(utf8.decoder).join("");
      if (response.statusCode >= 300) {
        print(responseContent);
        throw Exception(HTTP_CODES[response.statusCode]);
      }
      return responseContent;
    } catch (e) {
      print(e);
      throw ApiConnectionException(e.toString());
    }
  }

  /// Base function for http get requests
  ///
  /// ### Params
  /// - uri : The uri to call
  /// - (optional) data : The data to pass
  Future<String> getUrl(Uri uri, [String data = '', String token = '']) async {
    return callUrl(uri, HTTP_METHOD.GET, data, token);
  }

  /// Base function for http post requests
  ///
  /// ### Params
  /// - uri : The uri to call
  /// - (optional) data : The data to pass
  Future<String> postUrl(Uri uri, [String data = '', String token = '']) async {
    return callUrl(uri, HTTP_METHOD.POST, data, token);
  }

  /// Base function for http put requests
  ///
  /// ### Params
  /// - uri : The uri to call
  /// - (optional) data : The data to pass
  Future<String> putUrl(Uri uri, [String data = '', String token = '']) async {
    return callUrl(uri, HTTP_METHOD.PUT, data, token);
  }

  /// Base function for http delete requests
  ///
  /// ### Params
  /// - uri : The uri to call
  /// - (optional) data : The data to pass
  Future<String> deleteUrl(Uri uri,
      [String data = '', String token = '']) async {
    return callUrl(uri, HTTP_METHOD.DELETE, data, token);
  }
}
