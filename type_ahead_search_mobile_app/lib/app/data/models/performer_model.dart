class PerformerModel {
  final int id;
  final String name;
  final String type;
  final String? image;

  const PerformerModel({
    required this.id,
    required this.name,
    required this.type,
    this.image,
  });

  factory PerformerModel.fromJson(Map<String, dynamic> json) {
    return PerformerModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
    );
  }
}