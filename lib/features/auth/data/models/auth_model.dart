import 'package:meshwark_rider/features/auth/domain/entities/auth_entities.dart';

class AuthResultModel extends AuthResult {
  const AuthResultModel({
    required super.token,
    required super.userId,
    required super.role,
    required super.hasProfile,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthResultModel(
      token: data['token'] ?? '',
      userId: data['id'] ?? '',
      role: data['role'] ?? '',
      hasProfile: data['hasProfile'] ?? false,
    );
  }
}
