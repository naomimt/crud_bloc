import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioProvider {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    return _dio!;
  }
}
