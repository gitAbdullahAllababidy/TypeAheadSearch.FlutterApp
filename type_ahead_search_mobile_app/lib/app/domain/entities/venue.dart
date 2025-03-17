class VenueEntity {
  final int id;
  final String name;
  final String city;
  final String state;
  final String country;
  final String address;
  final double? latitude;
  final double? longitude;

  const VenueEntity({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
    this.latitude,
    this.longitude,
  });
}