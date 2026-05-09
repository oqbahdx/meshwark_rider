import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meshwark_rider/core/errors/failures.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<Either<Failure, Response>> get(
    String endPoint, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(endPoint, queryParameters: query);
      return Right(response);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    }
  }

  Future<Either<Failure, Response>> post(
    String endPoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(endPoint, data: data);
      return Right(response);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    }
  }

  Future<Either<Failure, Response>> put(
    String endPoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(endPoint, data: data);
      return Right(response);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    }
  }

  Future<Either<Failure, Response>> delete(String endPoint) async {
    try {
      final response = await _dio.delete(endPoint);
      return Right(response);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    }
  }
}
