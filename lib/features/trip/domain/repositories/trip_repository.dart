import 'package:dartz/dartz.dart';
import 'package:meshwark_rider/core/errors/failures.dart';
import 'package:meshwark_rider/features/trip/domain/entities/trip_entities.dart';

abstract class TripRepository {
  Future<Either<Failure, List<Trip>>> getTripHistory();
  Future<Either<Failure, Trip>> getTripDetails(String tripId);
  Future<Either<Failure, List<ServiceType>>> getServiceTypes();
  Future<Either<Failure, void>> cancelTrip(String tripId);
  Future<Either<Failure, void>> rateTrip(
      String tripId, double rating, String? comment);
}
