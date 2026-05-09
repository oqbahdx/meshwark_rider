import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/profile/domain/entities/profile_entities.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Profile>> updateProfile(ProfileUpdateParams params);
  Future<Either<Failure, void>> uploadImage(String imagePath);
}
