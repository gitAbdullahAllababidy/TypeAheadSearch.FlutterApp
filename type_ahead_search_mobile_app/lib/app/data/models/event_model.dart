import 'package:type_ahead_search_mobile_app/app/data/models/performer_model.dart';
import 'package:type_ahead_search_mobile_app/app/data/models/venue_model.dart';

class EventModel {
  final int id;
  final String title;
  final String type;
  final DateTime dateTime;
  final VenueModel venue;
  final List<PerformerModel> performers;
  final String url;
  final double score;

  const EventModel({
    required this.id,
    required this.title,
    required this.type,
    required this.dateTime,
    required this.venue,
    required this.performers,
    required this.url,
    required this.score,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      dateTime: DateTime.parse(json['datetime_utc']),
      venue: VenueModel.fromJson(json['venue']),
      performers: (json['performers'] as List)
          .map((performer) => PerformerModel.fromJson(performer))
          .toList(),
      url: json['url'],
      score: json['score']?.toDouble() ?? 0.0,
    );
  }
}





