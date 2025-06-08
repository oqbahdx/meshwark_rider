class TripModel {
  final String? id;
  final DateTime? date;
  final String? time;
  final String? startPoint;
  final String? endPoint;
  final double? price;
  final String? userId;
  final List<String>? riderIds;

  TripModel({
    this.id,
    this.date,
    this.time,
    this.startPoint,
    this.endPoint,
    this.price,
    this.userId,
    this.riderIds,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      time: json['time'] as String?,
      startPoint: json['startPoint'] as String?,
      endPoint: json['endPoint'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      userId: json['userId'] as String?,
      riderIds: json['riderIds'] != null ? List<String>.from(json['riderIds']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'time': time,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'price': price,
      'userId': userId,
      'riderIds': riderIds,
    };
  }
}