import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({this.message = 'API error', this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

Failure handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure('Connection timeout');
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final message =
          e.response?.data?['message']?.toString() ?? 'Server error';
      return ServerFailure('$message ($statusCode)');
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    default:
      return ServerFailure(e.message ?? 'Unknown error');
  }
}
