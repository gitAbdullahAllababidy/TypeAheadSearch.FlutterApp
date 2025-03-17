class VenueModel {
  final int id;
  final String name;
  final String city;
  final String state;
  final String country;
  final String address;
  final double? latitude;
  final double? longitude;

  const VenueModel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      state: json['state'] ?? '',
      country: json['country'],
      address: json['address'] ?? '',
      latitude: json['location'] != null ? json['location']['lat']?.toDouble() : null,
      longitude: json['location'] != null ? json['location']['lon']?.toDouble() : null,
    );
  }
}