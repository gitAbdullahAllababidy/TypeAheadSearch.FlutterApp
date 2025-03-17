import 'package:dartz/dartz.dart';
import 'package:type_ahead_search_mobile_app/app/core/errors/failure.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<EventEntity>>> searchEvents(String query);
  Future<Either<Failure, List<int>>> getFavoriteEventIds();
  Future<Either<Failure, void>> toggleFavorite(int eventId);
  Future<Either<Failure, List<String>>> getSearchHistory();
}



