class LoginResponseModel {
    int code;
    bool success;
    String message;
    Data data;
    List<dynamic> errors;

    LoginResponseModel({
        required this.code,
        required this.success,
        required this.message,
        required this.data,
        required this.errors,
    });

}

class Data {
    String token;
    String role;
    String id;
    bool hasProfile;

    Data({
        required this.token,
        required this.role,
        required this.id,
        required this.hasProfile,
    });

}
