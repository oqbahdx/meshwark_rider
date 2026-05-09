class Place {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class Driver {
  final String id;
  final String name;
  final String carModel;
  final String carColor;
  final String numberPlate;
  final double latitude;
  final double longitude;
  final double rating;
  final String? carImage;

  const Driver({
    required this.id,
    required this.name,
    required this.carModel,
    required this.carColor,
    required this.numberPlate,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.carImage,
  });
}

class MapRoute {
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;

  const MapRoute({
    required this.polylinePoints,
    required this.distance,
    required this.duration,
  });
}

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng({required this.latitude, required this.longitude});
}
