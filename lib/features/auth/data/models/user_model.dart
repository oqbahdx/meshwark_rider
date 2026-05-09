import 'package:meshwark_rider/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    super.phoneNumber,
    super.email,
    super.firstName,
    super.lastName,
    super.gender,
    super.hasProfile,
    super.personalImage,
    super.rating,
    super.completedTrips,
    super.isApproved,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      hasProfile: json['hasProfile'] ?? false,
      personalImage: json['personalImagePath'],
      rating: json['rating']?.toDouble(),
      completedTrips: json['completedTrips'],
      isApproved: json['isApproved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'hasProfile': hasProfile,
      'personalImagePath': personalImage,
      'rating': rating,
      'completedTrips': completedTrips,
      'isApproved': isApproved,
    };
  }
}
