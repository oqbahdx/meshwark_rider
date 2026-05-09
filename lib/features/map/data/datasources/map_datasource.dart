import 'package:meshwark_rider/core/constants/constants.dart';
import 'package:meshwark_rider/core/network/api_client.dart';
import 'package:meshwark_rider/features/map/data/models/map_models.dart';
import 'package:meshwark_rider/features/map/domain/entities/map_entities.dart';

abstract class MapRemoteDataSource {
  Future<List<DriverModel>> getNearbyDrivers(double lat, double lng);
  Future<List<PlaceModel>> searchPlaces(String query);
  Future<MapRouteModel> getRoute(Place origin, Place destination);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final ApiClient apiClient;

  MapRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<DriverModel>> getNearbyDrivers(double lat, double lng) async {
    final result = await apiClient.get(
      '${ApiConstants.baseUrl}/api/Driver/nearby',
      query: {'lat': lat, 'lng': lng},
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => (response.data['data'] as List)
          .map((d) => DriverModel.fromJson(d))
          .toList(),
    );
  }

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    final result = await apiClient.get(
      '/api/Places/search',
      query: {'q': query},
    );
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => (response.data['data'] as List)
          .map((p) => PlaceModel.fromJson(p))
          .toList(),
    );
  }

  @override
  Future<MapRouteModel> getRoute(Place origin, Place destination) async {
    final result = await apiClient.post('/api/Map/route', data: {
      'origin': {'lat': origin.latitude, 'lng': origin.longitude},
      'destination': {
        'lat': destination.latitude,
        'lng': destination.longitude
      },
    });
    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => MapRouteModel.fromJson(response.data['data']),
    );
  }
}
