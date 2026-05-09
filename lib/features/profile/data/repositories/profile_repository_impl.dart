import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/profile/data/datasources/profile_datasource.dart';
import 'package:meshwark_rider/features/profile/domain/entities/profile_entities.dart';
import 'package:meshwark_rider/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      final profile = await remoteDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(
      ProfileUpdateParams params) async {
    try {
      final profile = await remoteDataSource.updateProfile(params);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadImage(String imagePath) async {
    try {
      await remoteDataSource.uploadImage(imagePath);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
