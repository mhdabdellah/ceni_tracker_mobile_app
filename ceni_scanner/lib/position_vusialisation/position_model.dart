class ObjectPosition {
  final double latitude;
  final double longitude;

  ObjectPosition({
    required this.latitude,
    required this.longitude,
  });

  factory ObjectPosition.fromJson(Map<String, dynamic> json) {
    return ObjectPosition(
      latitude: json['latitude'],
      longitude:json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}