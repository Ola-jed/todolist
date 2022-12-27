import 'package:todolist/api/core/api_response.dart';

class ApiSuccess<T> extends ApiResponse<T> {
  ApiSuccess(this.value);

  final T value;

  @override
  String toString() {
    return 'Api success (value : $value)';
  }
}