class PerformerEntity {
  final int id;
  final String name;
  final String type;
  final String? image;

  const PerformerEntity({
    required this.id,
    required this.name,
    required this.type,
    this.image,
  });
}