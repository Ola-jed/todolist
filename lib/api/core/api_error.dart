import 'package:todolist/api/core/api_response.dart';

class ApiError<T> extends ApiResponse<T> {
  ApiError({this.message, required this.code});

  final String? message;
  final int code;

  @override
  String toString() {
    final messageStr = message == null ? '' : ', message : $message';
    return 'Api error (code : $code $messageStr)';
  }
}
