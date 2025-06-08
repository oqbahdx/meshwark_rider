class RegisterModel {
  final int code;
  final bool success;
  final String message;
  final Data? data;
  final List<dynamic>? errors;

  RegisterModel({
    required this.code,
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      code: json['code'] as int,
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      errors:
          json['errors'] != null ? List<dynamic>.from(json['errors']) : <dynamic>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['code'] = code;
    dataMap['success'] = success;
    dataMap['message'] = message;
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    dataMap['errors'] = errors;
    return dataMap;
  }
}

class Data {
  final String id;
  final String phoneNumber;
  final String email;
  final String password;
  final String fcmToken;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? personalImagePath;
  final bool hasProfile;
  final String? gender;
  final bool? isOnline;
  final int? availableSeats;
  final int? reservedSeats;
  final String? nextDestination;
  final String? currentDestination;
  final double? longitude;
  final double? latitude;
  final String? carColor;
  final String? carYear;
  final String? carModel;
  final String? typeOfTrip;
  final String? plateImage;
  final String? insuranceImage;
  final String? numberPlate;
  final String? licenseImage;
  final double? rating;
  final int? completedTrips;
  final int? canceledTrips;
  final bool? isTripActive;
  final String? idImage;
  final bool isApproved;
  final String? otp;
  final String? otpExpirationTime;
  final DateTime? createdAt;
  final List<dynamic>? notifications;
  final List<dynamic>? trips;
  final List<dynamic>? ratingsGiven;
  final List<dynamic>? ratingsReceived;

  Data({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.fcmToken,
    required this.role,
    this.firstName,
    this.lastName,
    this.personalImagePath,
    required this.hasProfile,
    this.gender,
    this.isOnline,
    this.availableSeats,
    this.reservedSeats,
    this.nextDestination,
    this.currentDestination,
    this.longitude,
    this.latitude,
    this.carColor,
    this.carYear,
    this.carModel,
    this.typeOfTrip,
    this.plateImage,
    this.insuranceImage,
    this.numberPlate,
    this.licenseImage,
    this.rating,
    this.completedTrips,
    this.canceledTrips,
    this.isTripActive,
    this.idImage,
    required this.isApproved,
    this.otp,
    this.otpExpirationTime,
    this.createdAt,
    this.notifications,
    this.trips,
    this.ratingsGiven,
    this.ratingsReceived,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      fcmToken: json['fcmToken'] as String,
      role: json['role'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      personalImagePath: json['personalImagePath'] as String?,
      hasProfile: json['hasProfile'] as bool,
      gender: json['gender'] as String?,
      isOnline: json['isOnline'] as bool?,
      availableSeats: json['availableSeats'] as int?,
      reservedSeats: json['reservedSeats'] as int?,
      nextDestination: json['nextDestination'] as String?,
      currentDestination: json['currentDestination'] as String?,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      carColor: json['carColor'] as String?,
      carYear: json['carYear'] as String?,
      carModel: json['carModel'] as String?,
      typeOfTrip: json['typeOfTrip'] as String?,
      plateImage: json['plateImage'] as String?,
      insuranceImage: json['insuranceImage'] as String?,
      numberPlate: json['numberPlate'] as String?,
      licenseImage: json['licenseImage'] as String?,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      completedTrips: json['completedTrips'] as int?,
      canceledTrips: json['canceledTrips'] as int?,
      isTripActive: json['isTripActive'] as bool?,
      idImage: json['idImage'] as String?,
      isApproved: json['isApproved'] as bool,
      otp: json['otp'] as String?,
      otpExpirationTime: json['otpExpirationTime'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      notifications: json['notifications'] != null
          ? List<dynamic>.from(json['notifications'])
          : <dynamic>[],
      trips: json['trips'] != null
          ? List<dynamic>.from(json['trips'])
          : <dynamic>[],
      ratingsGiven: json['ratingsGiven'] != null
          ? List<dynamic>.from(json['ratingsGiven'])
          : <dynamic>[],
      ratingsReceived: json['ratingsReceived'] != null
          ? List<dynamic>.from(json['ratingsReceived'])
          : <dynamic>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['id'] = id;
    dataMap['phoneNumber'] = phoneNumber;
    dataMap['email'] = email;
    dataMap['password'] = password;
    dataMap['fcmToken'] = fcmToken;
    dataMap['role'] = role;
    dataMap['firstName'] = firstName;
    dataMap['lastName'] = lastName;
    dataMap['personalImagePath'] = personalImagePath;
    dataMap['hasProfile'] = hasProfile;
    dataMap['gender'] = gender;
    dataMap['isOnline'] = isOnline;
    dataMap['availableSeats'] = availableSeats;
    dataMap['reservedSeats'] = reservedSeats;
    dataMap['nextDestination'] = nextDestination;
    dataMap['currentDestination'] = currentDestination;
    dataMap['longitude'] = longitude;
    dataMap['latitude'] = latitude;
    dataMap['carColor'] = carColor;
    dataMap['carYear'] = carYear;
    dataMap['carModel'] = carModel;
    dataMap['typeOfTrip'] = typeOfTrip;
    dataMap['plateImage'] = plateImage;
    dataMap['insuranceImage'] = insuranceImage;
    dataMap['numberPlate'] = numberPlate;
    dataMap['licenseImage'] = licenseImage;
    dataMap['rating'] = rating;
    dataMap['completedTrips'] = completedTrips;
    dataMap['canceledTrips'] = canceledTrips;
    dataMap['isTripActive'] = isTripActive;
    dataMap['idImage'] = idImage;
    dataMap['isApproved'] = isApproved;
    dataMap['otp'] = otp;
    dataMap['otpExpirationTime'] = otpExpirationTime;
    dataMap['createdAt'] = createdAt?.toIso8601String();
    dataMap['notifications'] = notifications;
    dataMap['trips'] = trips;
    dataMap['ratingsGiven'] = ratingsGiven;
    dataMap['ratingsReceived'] = ratingsReceived;
    return dataMap;
  }
}
