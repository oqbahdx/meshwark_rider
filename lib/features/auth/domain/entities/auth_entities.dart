class AuthResult {
  final String token;
  final String userId;
  final String role;
  final bool hasProfile;

  const AuthResult({
    required this.token,
    required this.userId,
    required this.role,
    required this.hasProfile,
  });
}

class LoginParams {
  final String phoneNumber;
  final String password;

  const LoginParams({required this.phoneNumber, required this.password});
}

class RegisterParams {
  final String phoneNumber;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterParams({
    required this.phoneNumber,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

class ForgotPasswordParams {
  final String phoneNumber;

  const ForgotPasswordParams({required this.phoneNumber});
}

class VerifyCodeParams {
  final String phoneNumber;
  final String code;
  final String newPassword;

  const VerifyCodeParams({
    required this.phoneNumber,
    required this.code,
    required this.newPassword,
  });
}
