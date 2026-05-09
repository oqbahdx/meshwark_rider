import 'package:meshwark_rider/features/map/domain/entities/map_entities.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    required super.carModel,
    required super.carColor,
    required super.numberPlate,
    required super.latitude,
    required super.longitude,
    required super.rating,
    super.carImage,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      carModel: json['carModel'] ?? '',
      carColor: json['carColor'] ?? '',
      numberPlate: json['numberPlate'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      carImage: json['carImage'],
    );
  }
}

class MapRouteModel extends MapRoute {
  const MapRouteModel({
    required super.polylinePoints,
    required super.distance,
    required super.duration,
  });

  factory MapRouteModel.fromJson(Map<String, dynamic> json) {
    final points = (json['points'] as List<dynamic>?)
            ?.map((p) => LatLng(
                  latitude: (p['lat'] as num).toDouble(),
                  longitude: (p['lng'] as num).toDouble(),
                ))
            .toList() ??
        [];
    return MapRouteModel(
      polylinePoints: points,
      distance: json['distance'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}
