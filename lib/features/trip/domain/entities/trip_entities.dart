class Trip {
  final String id;
  final String driverId;
  final String driverName;
  final String origin;
  final String destination;
  final double price;
  final DateTime createdAt;
  final String status;
  final double? driverRating;

  const Trip({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.origin,
    required this.destination,
    required this.price,
    required this.createdAt,
    required this.status,
    this.driverRating,
  });
}

class ServiceType {
  final String id;
  final String name;
  final String imageUrl;
  final double basePrice;
  final double pricePerKm;

  const ServiceType({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.basePrice,
    required this.pricePerKm,
  });
}
