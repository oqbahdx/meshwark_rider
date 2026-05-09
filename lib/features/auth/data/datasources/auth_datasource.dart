import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meshwark_rider/core/constants/constants.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/core/network/api_client.dart';
import 'package:meshwark_rider/features/auth/data/models/auth_model.dart';
import 'package:meshwark_rider/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> login(String phone, String password);
  Future<AuthResultModel> register(
      String phone, String password, String firstName, String lastName);
  Future<void> forgotPassword(String phoneNumber);
  Future<void> verifyCode(String phone, String code, String newPassword);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResultModel> login(String phone, String password) async {
    final result = await apiClient.post(
      ApiConstants.loginEndPoint,
      data: {'phoneNumber': phone, 'password': password},
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => AuthResultModel.fromJson(response.data['data']),
    );
  }

  @override
  Future<AuthResultModel> register(
      String phone, String password, String firstName, String lastName) async {
    final result = await apiClient.post(
      ApiConstants.registerEndPoint,
      data: {
        'phoneNumber': phone,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      },
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => AuthResultModel.fromJson(response.data['data']),
    );
  }

  @override
  Future<void> forgotPassword(String phoneNumber) async {
    await apiClient.post(
      ApiConstants.forgotPasswordEndPoint,
      data: {'phoneNumber': phoneNumber},
    );
  }

  @override
  Future<void> verifyCode(String phone, String code, String newPassword) async {
    await apiClient.post(
      ApiConstants.verifyCodeEndPoint,
      data: {'phoneNumber': phone, 'code': code, 'newPassword': newPassword},
    );
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiConstants.logoutEndPoint, data: {});
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final result =
        await apiClient.get('${ApiConstants.profileEndPoint}/current');
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => UserModel.fromJson(response.data['data']),
    );
  }
}
