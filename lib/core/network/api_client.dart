import 'dart:convert';

import 'package:dio/dio.dart';

import '../utils/typedefs.dart';

enum ApiErrorType {
  cancelled,
  timeout,
  badResponse,
  network,
  invalidResponse,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? path;
  final ApiErrorType type;
  final dynamic data;
  final Object? cause;

  const ApiException({
    required this.message,
    required this.type,
    this.statusCode,
    this.path,
    this.data,
    this.cause,
  });

  @override
  String toString() {
    final buffer = StringBuffer('ApiException($type');
    if (statusCode != null) buffer.write(', statusCode: $statusCode');
    if (path != null) buffer.write(', path: $path');
    buffer.write('): $message');
    return buffer.toString();
  }
}

class ApiClient {
  ApiClient({Dio? dio, String? baseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl:
                  baseUrl ??
                  const String.fromEnvironment(
                    'API_BASE_URL',
                    defaultValue: '',
                  ),
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              responseType: ResponseType.json,
              headers: const {
                'accept': 'application/json',
                'content-type': 'application/json',
              },
            ),
          );

  final Dio _dio;

  Future<JsonMap> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      path,
      // No request body for GET; some servers reject bodies with 406/400.
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<JsonMap> post(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      path,
      method: 'POST',
      data: body,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<JsonMap> put(
    String path,
    JsonMap body, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      path,
      method: 'PUT',
      data: body,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<JsonMap> patch(
    String path,
    JsonMap body, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      path,
      method: 'PATCH',
      data: body,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<JsonMap> delete(
    String path, {
    JsonMap? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      path,
      method: 'DELETE',
      data: body,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<JsonMap> _request(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      );
      return _normalizeResponse(response.data, path);
    } on DioException catch (error) {
      throw _mapDioException(error, path);
    } catch (error) {
      throw ApiException(
        message: 'Unexpected error',
        type: ApiErrorType.unknown,
        path: path,
        cause: error,
      );
    }
  }

  JsonMap _normalizeResponse(dynamic data, String path) {
    if (data == null) {
      return <String, dynamic>{};
    }
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
        return <String, dynamic>{'data': decoded};
      } catch (error) {
        throw ApiException(
          message: 'Invalid response format',
          type: ApiErrorType.invalidResponse,
          path: path,
          data: data,
          cause: error,
        );
      }
    }
    return <String, dynamic>{'data': data};
  }

  ApiException _mapDioException(DioException error, String path) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          type: ApiErrorType.cancelled,
          path: path,
          statusCode: statusCode,
          data: data,
          cause: error,
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Request timed out',
          type: ApiErrorType.timeout,
          path: path,
          statusCode: statusCode,
          data: data,
          cause: error,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message:
              _extractMessage(data) ??
              'Request failed${statusCode != null ? ' ($statusCode)' : ''}',
          type: ApiErrorType.badResponse,
          path: path,
          statusCode: statusCode,
          data: data,
          cause: error,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Connection error',
          type: ApiErrorType.network,
          path: path,
          statusCode: statusCode,
          data: data,
          cause: error,
        );
      case DioExceptionType.badCertificate:
        return ApiException(
          message: 'Bad SSL certificate',
          type: ApiErrorType.network,
          path: path,
          statusCode: statusCode,
          data: data,
          cause: error,
        );
      case DioExceptionType.unknown:
        return ApiException(
          message: 'Unexpected network error',
          type: ApiErrorType.unknown,
          path: path,
          statusCode: statusCode,
          data: data,
          cause: error,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['error'] ?? data['detail'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }
}
