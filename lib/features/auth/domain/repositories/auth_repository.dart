import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/auth/domain/entities/auth_entities.dart';
import 'package:meshwark_rider/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login(LoginParams params);
  Future<Either<Failure, AuthResult>> register(RegisterParams params);
  Future<Either<Failure, void>> forgotPassword(ForgotPasswordParams params);
  Future<Either<Failure, void>> verifyCode(VerifyCodeParams params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();
}
