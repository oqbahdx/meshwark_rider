class LoginModel {
  int? code;
  bool? success;
  String? message;
  Data? data;
  List<String>? errors;

  LoginModel({this.code, this.success, this.message, this.data, this.errors});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      code: json['code'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}

class Data {
  String? token;
  String? role;
  String? id;
  bool? hasProfile;

  Data({this.token, this.role, this.id, this.hasProfile});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'],
      role: json['role'],
      id: json['id'],
      hasProfile: json['hasProfile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'role': role,
      'id': id,
      'hasProfile': hasProfile,
    };}}