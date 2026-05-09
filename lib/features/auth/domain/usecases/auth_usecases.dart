import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/core/usecases/usecase.dart';
import 'package:meshwark_rider/features/auth/domain/entities/auth_entities.dart';
import 'package:meshwark_rider/features/auth/domain/entities/user.dart';
import 'package:meshwark_rider/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthResult, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResult>> call(LoginParams params) {
    return repository.login(params);
  }
}

class RegisterUseCase implements UseCase<AuthResult, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResult>> call(RegisterParams params) {
    return repository.register(params);
  }
}

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(params);
  }
}

class VerifyCodeUseCase implements UseCase<void, VerifyCodeParams> {
  final AuthRepository repository;

  VerifyCodeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyCodeParams params) {
    return repository.verifyCode(params);
  }
}

class GetCurrentUserUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
