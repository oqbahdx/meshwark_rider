class GetAllDriversModel {
  int? code;
  bool? success;
  String? message;
  List<Data>? data;
  List<String>? errors;

  GetAllDriversModel(
      {this.code, this.success, this.message, this.data, this.errors});

  GetAllDriversModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    errors = json['errors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['errors'] = this.errors;
    return data;
  }
}

class Data {
  String? id;
  String? phoneNumber;
  String? email;
  String? firstName;
  String? lastName;
  String? personalImagePath;
  bool? hasProfile;
  String? gender;
  bool? isOnline;
  int? availableSeats;
  int? reservedSeats;
  String? nextDestination;
  String? currentDestination;
  double? longitude;  // Change from int? to double?
  double? latitude;   // Change from int? to double?
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
  bool? isTripActive;
  String? idImage;
  bool? isApproved;
  String? otp;
  String? otpExpirationTime;
  String? createdAt;

  Data(
      {this.id,
      this.phoneNumber,
      this.email,
      this.firstName,
      this.lastName,
      this.personalImagePath,
      this.hasProfile,
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
      this.isApproved,
      this.otp,
      this.otpExpirationTime,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    personalImagePath = json['PersonalImagePath'];
    hasProfile = json['HasProfile'];
    gender = json['Gender'];
    isOnline = json['IsOnline'];
    availableSeats = json['AvailableSeats'];
    reservedSeats = json['ReservedSeats'];
    nextDestination = json['NextDestination'];
    currentDestination = json['CurrentDestination'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
    carColor = json['CarColor'];
    carYear = json['CarYear'];
    carModel = json['CarModel'];
    typeOfTrip = json['TypeOfTrip'];
    plateImage = json['PlateImage'];
    insuranceImage = json['InsuranceImage'];
      numberPlate = json['NumberPlate'];
    licenseImage = json['LicenseImage'];
    rating = json['Rating'];
    completedTrips = json['CompletedTrips'];
    canceledTrips = json['CanceledTrips'];
    isTripActive = json['IsTripActive'];
    idImage = json['IdImage'];
    
    isApproved = json['IsApproved'];
    otp = json['Otp'];
    otpExpirationTime = json['OtpExpirationTime'];
    createdAt = json['CreatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['personalImagePath'] = this.personalImagePath;
    data['hasProfile'] = this.hasProfile;
    data['gender'] = this.gender;
    data['isOnline'] = this.isOnline;
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
    data['isTripActive'] = this.isTripActive;
    data['idImage'] = this.idImage;
    data['isApproved'] = this.isApproved;
    data['otp'] = this.otp;
    data['otpExpirationTime'] = this.otpExpirationTime;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
