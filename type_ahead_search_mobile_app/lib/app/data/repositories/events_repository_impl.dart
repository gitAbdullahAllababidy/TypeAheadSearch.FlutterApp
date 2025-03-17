import 'package:dartz/dartz.dart';
import 'package:type_ahead_search_mobile_app/app/core/constants/api_constants.dart';
import 'package:type_ahead_search_mobile_app/app/core/errors/failure.dart';
import 'package:type_ahead_search_mobile_app/app/data/models/event_model.dart';
import 'package:type_ahead_search_mobile_app/app/data/providers/api_provider.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/performer.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/venue.dart';
import 'package:type_ahead_search_mobile_app/app/domain/repositories/events_repository.dart';
import 'package:type_ahead_search_mobile_app/app/services/storage_service.dart';

class EventsRepositoryImpl implements EventsRepository {
  final ApiProvider _apiProvider;
  final StorageService _storageService;

  // Cache for recent search results
  final Map<String, List<EventEntity>> _searchCache = {};
  final int _maxCacheItems = 5;

  EventsRepositoryImpl({
    required ApiProvider apiProvider,
    required StorageService storageService,
  }) : _apiProvider = apiProvider,
       _storageService = storageService;

  @override
  Future<Either<Failure, List<EventEntity>>> searchEvents(String query) async {
    if (query.isEmpty) return const Right([]);

    try {
      // Check cache first
      if (_searchCache.containsKey(query)) {
        return Right(_searchCache[query]!);
      }

      final response = await _apiProvider.getEvents(query);
      
      return response.fold(
        (failure) => Left(failure),
        (data) {
          final List<EventModel> eventModels = (data['events'] as List)
              .map((event) => EventModel.fromJson(event))
              .toList();

          final favoriteIds = _storageService.getFavorites();
          
          final events = eventModels.map((model) {
            return EventEntity(
              id: model.id,
              title: model.title,
              type: model.type,
              dateTime: model.dateTime,
              venue: VenueEntity(
                id: model.venue.id,
                name: model.venue.name,
                city: model.venue.city,
                state: model.venue.state,
                country: model.venue.country,
                address: model.venue.address,
                latitude: model.venue.latitude,
                longitude: model.venue.longitude,
              ),
              performers: model.performers.map((p) => PerformerEntity(
                id: p.id,
                name: p.name,
                type: p.type,
                image: p.image,
              )).toList(),
              url: model.url,
              score: model.score,
              isFavorite: favoriteIds.contains(model.id),
            );
          }).toList();

          // Save to search history
          _storageService.addToSearchHistory(query);
          
          // Update cache
          _updateCache(query, events);
          
          return Right(events);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  void _updateCache(String query, List<EventEntity> events) {
    // Add to cache
    _searchCache[query] = events;
    
    // Remove oldest items if cache is too large
    if (_searchCache.length > _maxCacheItems) {
      final oldestKey = _searchCache.keys.first;
      _searchCache.remove(oldestKey);
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteEventIds() async {
    try {
      return Right(_storageService.getFavorites());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(int eventId) async {
    try {
      await _storageService.toggleFavorite(eventId);
      
      // Update cache entries
      for (final key in _searchCache.keys) {
        final events = _searchCache[key]!;
        for (final event in events) {
          if (event.id == eventId) {
            event.isFavorite = !event.isFavorite;
          }
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchHistory() async {
    try {
      return Right(_storageService.getSearchHistory());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
