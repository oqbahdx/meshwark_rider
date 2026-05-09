library login_bloc;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meshwark_rider/features/auth/domain/entities/auth_entities.dart';
import 'package:meshwark_rider/features/auth/domain/usecases/auth_usecases.dart';
import 'package:meshwark_rider/core/usecases/usecase.dart';

part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  bool _isPasswordVisible = false;

  LoginBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<LogoutRequested>(_onLogoutRequested);
  }

  bool get isPasswordVisible => _isPasswordVisible;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await loginUseCase(
      LoginParams(phoneNumber: event.phone, password: event.password),
    );
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (_) => emit(LoginSuccess()),
    );
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginPasswordVisible(_isPasswordVisible));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    await logoutUseCase(const NoParams());
    emit(LoginInitial());
  }
}
