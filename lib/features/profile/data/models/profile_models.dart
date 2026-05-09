import 'package:meshwark_rider/features/profile/domain/entities/profile_entities.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    super.gender,
    super.personalImage,
    super.carInfo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender'],
      personalImage: json['personalImagePath'],
      carInfo: json['carInfo'] != null
          ? CarInfoModel.fromJson(json['carInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'personalImagePath': personalImage,
      'carInfo': carInfo?.toJson(),
    };
  }
}

class CarInfoModel extends CarInfo {
  const CarInfoModel({
    required super.model,
    required super.color,
    required super.year,
    required super.numberPlate,
    super.plateImage,
    super.licenseImage,
    super.insuranceImage,
  });

  factory CarInfoModel.fromJson(Map<String, dynamic> json) {
    return CarInfoModel(
      model: json['model'] ?? '',
      color: json['color'] ?? '',
      year: json['year'] ?? 0,
      numberPlate: json['numberPlate'] ?? '',
      plateImage: json['plateImage'],
      licenseImage: json['licenseImage'],
      insuranceImage: json['insuranceImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'color': color,
      'year': year,
      'numberPlate': numberPlate,
      'plateImage': plateImage,
      'licenseImage': licenseImage,
      'insuranceImage': insuranceImage,
    };
  }
}
