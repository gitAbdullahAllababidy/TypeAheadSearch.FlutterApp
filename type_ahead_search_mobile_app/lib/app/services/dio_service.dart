import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/core/constants/api_constants.dart';

class DioService extends GetxService {
  late final Dio _dio;

  DioService() {
    _initDio();
  }

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      responseType: ResponseType.json,
    ));

    // Add interceptors for logging in debug mode only
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<dynamic> get(String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path, 
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    if (e is DioException) {
      // Pass cancellation exceptions through
      if (e.type == DioExceptionType.cancel) {
        return e;
      }
      
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timeout. Please check your internet connection.');
        case DioExceptionType.badResponse:
          return Exception('Server error. Status code: ${e.response?.statusCode}');
        case DioExceptionType.connectionError:
          return Exception('Connection error. Please check your internet connection.');
        default:
          return Exception('Unknown error occurred: ${e.message}');
      }
    }
    return Exception('Unexpected error occurred: $e');
  }

  @override
  void onClose() {
    _dio.close(force: true);
    super.onClose();
  }

  static DioService init() {
    return DioService();
  }
}