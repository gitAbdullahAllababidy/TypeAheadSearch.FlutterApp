import 'package:type_ahead_search_mobile_app/app/domain/entities/performer.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/venue.dart';

class EventEntity {
  final int id;
  final String title;
  final String type;
  final DateTime dateTime;
  final VenueEntity venue;
  final List<PerformerEntity> performers;
  final String url;
  final double score;
  bool isFavorite;

  EventEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.dateTime,
    required this.venue,
    required this.performers,
    required this.url,
    required this.score,
    this.isFavorite = false,
  });
}




