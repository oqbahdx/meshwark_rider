import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/app/secure_token_storage.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/auth/data/datasources/auth_datasource.dart';
import 'package:meshwark_rider/features/auth/domain/entities/auth_entities.dart';
import 'package:meshwark_rider/features/auth/domain/entities/user.dart';
import 'package:meshwark_rider/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthResult>> login(LoginParams params) async {
    try {
      final result = await remoteDataSource.login(
        params.phoneNumber,
        params.password,
      );
      await SecureTokenStorage.saveToken(result.token);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register(RegisterParams params) async {
    try {
      final result = await remoteDataSource.register(
        params.phoneNumber,
        params.password,
        params.firstName,
        params.lastName,
      );
      await SecureTokenStorage.saveToken(result.token);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(
      ForgotPasswordParams params) async {
    try {
      await remoteDataSource.forgotPassword(params.phoneNumber);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode(VerifyCodeParams params) async {
    try {
      await remoteDataSource.verifyCode(
        params.phoneNumber,
        params.code,
        params.newPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await SecureTokenStorage.deleteToken();
      return const Right(null);
    } catch (e) {
      await SecureTokenStorage.deleteToken();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    final token = await SecureTokenStorage.readToken();
    return Right(token != null && token.isNotEmpty);
  }
}
