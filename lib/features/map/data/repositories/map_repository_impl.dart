import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/map/data/datasources/map_datasource.dart';
import 'package:meshwark_rider/features/map/domain/entities/map_entities.dart';
import 'package:meshwark_rider/features/map/domain/repositories/map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Driver>>> getNearbyDrivers(
      double lat, double lng) async {
    try {
      final drivers = await remoteDataSource.getNearbyDrivers(lat, lng);
      return Right(drivers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Place>>> searchPlaces(String query) async {
    try {
      final places = await remoteDataSource.searchPlaces(query);
      return Right(places);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MapRoute>> getRoute(
      Place origin, Place destination) async {
    try {
      final route = await remoteDataSource.getRoute(origin, destination);
      return Right(route);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDriverLocation(
      double lat, double lng) async {
    try {
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
