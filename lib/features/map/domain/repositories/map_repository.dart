import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/map/domain/entities/map_entities.dart';

abstract class MapRepository {
  Future<Either<Failure, List<Driver>>> getNearbyDrivers(
      double lat, double lng);
  Future<Either<Failure, List<Place>>> searchPlaces(String query);
  Future<Either<Failure, MapRoute>> getRoute(Place origin, Place destination);
  Future<Either<Failure, void>> updateDriverLocation(double lat, double lng);
}
