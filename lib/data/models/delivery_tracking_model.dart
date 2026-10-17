/// Delivery tracking payload shape reserved for the future courier GPS API.
/// No device location or network tracking is started by this model.
class DeliveryTrackingModel {
  const DeliveryTrackingModel({
    this.latitude,
    this.longitude,
    this.destinationLatitude,
    this.destinationLongitude,
    this.courierName,
    this.etaMinutes,
    this.updatedAt,
  });

  final double? latitude;
  final double? longitude;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? courierName;
  final int? etaMinutes;
  final DateTime? updatedAt;

  bool get hasCourierLocation => latitude != null && longitude != null;

  factory DeliveryTrackingModel.fromJson(Map<String, dynamic> json) {
    double? number(dynamic value) => value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');
    return DeliveryTrackingModel(
      latitude: number(json['latitude']),
      longitude: number(json['longitude']),
      destinationLatitude: number(json['destinationLatitude']),
      destinationLongitude: number(json['destinationLongitude']),
      courierName: json['courierName']?.toString(),
      etaMinutes: (json['etaMinutes'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'destinationLatitude': destinationLatitude,
    'destinationLongitude': destinationLongitude,
    'courierName': courierName,
    'etaMinutes': etaMinutes,
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
