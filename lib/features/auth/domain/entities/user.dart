class User {
  final String id;
  final String? phoneNumber;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final bool hasProfile;
  final String? personalImage;
  final double? rating;
  final int? completedTrips;
  final bool? isApproved;

  const User({
    required this.id,
    this.phoneNumber,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.hasProfile = false,
    this.personalImage,
    this.rating,
    this.completedTrips,
    this.isApproved,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
