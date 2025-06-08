class UserModel {
      
  int? code;
  bool? success;
  String? message;
  Data? data;
  List<String>? errors;

  UserModel({this.code, this.success, this.message, this.data, this.errors});

  UserModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    errors = json['errors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errors'] = this.errors;
    return data;
  }
}

class Data {
  String? id;
  String? role;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? gender;
  bool? hasProfile;
  bool? isOnline;
  bool? isApproved;
  int? availableSeats;
  int? reservedSeats;
  String? nextDestination;
  String? currentDestination;
  int? longitude;
  int? latitude;
  String? carColor;
  int? carYear;
  String? carModel;
  String? typeOfTrip;
  String? plateImage;
  String? insuranceImage;
  String? numberPlate;
  String? licenseImage;
  int? rating;
  int? completedTrips;
  int? canceledTrips;
  String? personalImagePath;
  String? fcmToken;
  int? totalTrips;

  Data(
      {this.id,
      this.role,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.gender,
      this.hasProfile,
      this.isOnline,
      this.isApproved,
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
      this.personalImagePath,
      this.fcmToken,
      this.totalTrips});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    gender = json['gender'];
    hasProfile = json['hasProfile'];
    isOnline = json['isOnline'];
    isApproved = json['isApproved'];
    availableSeats = json['availableSeats'];
    reservedSeats = json['reservedSeats'];
    nextDestination = json['nextDestination'];
    currentDestination = json['currentDestination'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    carColor = json['carColor'];
    carYear = json['carYear'];
    carModel = json['carModel'];
    typeOfTrip = json['typeOfTrip'];
    plateImage = json['plateImage'];
    insuranceImage = json['insuranceImage'];
    numberPlate = json['numberPlate'];
    licenseImage = json['licenseImage'];
    rating = json['rating'];
    completedTrips = json['completedTrips'];
    canceledTrips = json['canceledTrips'];
    personalImagePath = json['personalImagePath'];
    fcmToken = json['fcmToken'];
    totalTrips = json['totalTrips'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['hasProfile'] = this.hasProfile;
    data['isOnline'] = this.isOnline;
    data['isApproved'] = this.isApproved;
    data['availableSeats'] = this.availableSeats;
    data['reservedSeats'] = this.reservedSeats;
    data['nextDestination'] = this.nextDestination;
    data['currentDestination'] = this.currentDestination;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['carColor'] = this.carColor;
    data['carYear'] = this.carYear;
    data['carModel'] = this.carModel;
    data['typeOfTrip'] = this.typeOfTrip;
    data['plateImage'] = this.plateImage;
    data['insuranceImage'] = this.insuranceImage;
    data['numberPlate'] = this.numberPlate;
    data['licenseImage'] = this.licenseImage;
    data['rating'] = this.rating;
    data['completedTrips'] = this.completedTrips;
    data['canceledTrips'] = this.canceledTrips;
    data['personalImagePath'] = this.personalImagePath;
    data['fcmToken'] = this.fcmToken;
    data['totalTrips'] = this.totalTrips;
    return data;
  }
}
