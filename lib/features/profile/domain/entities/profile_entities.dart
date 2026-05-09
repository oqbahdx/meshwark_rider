class Profile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? gender;
  final String? personalImage;
  final CarInfo? carInfo;

  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.gender,
    this.personalImage,
    this.carInfo,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'personalImage': personalImage,
        'carInfo': carInfo?.toJson(),
      };
}

class CarInfo {
  final String model;
  final String color;
  final int year;
  final String numberPlate;
  final String? plateImage;
  final String? licenseImage;
  final String? insuranceImage;

  const CarInfo({
    required this.model,
    required this.color,
    required this.year,
    required this.numberPlate,
    this.plateImage,
    this.licenseImage,
    this.insuranceImage,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'color': color,
        'year': year,
        'numberPlate': numberPlate,
        'plateImage': plateImage,
        'licenseImage': licenseImage,
        'insuranceImage': insuranceImage,
      };
}

class ProfileUpdateParams {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? personalImage;
  final CarInfo? carInfo;

  const ProfileUpdateParams({
    this.firstName,
    this.lastName,
    this.gender,
    this.personalImage,
    this.carInfo,
  });
}
