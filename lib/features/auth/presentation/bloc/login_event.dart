part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  final String phone;
  final String password;

  const LoginRequested({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

class TogglePasswordVisibility extends LoginEvent {}

class LogoutRequested extends LoginEvent {}
