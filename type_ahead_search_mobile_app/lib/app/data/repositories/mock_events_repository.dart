import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/core/constants/api_constants.dart';
import 'package:type_ahead_search_mobile_app/app/core/errors/failure.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/performer.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/venue.dart';
import 'package:type_ahead_search_mobile_app/app/domain/repositories/events_repository.dart';




class MockEventsRepository implements EventsRepository {

  final RxList<int> _favoriteIds = <int>[].obs;
  

  final RxList<String> _searchHistory = <String>[].obs;
  

  final List<EventEntity> _mockEvents = [
    EventEntity(
      id: 5183269,
      title: 'Texas Rangers at Seattle Mariners',
      type: 'mlb',
      dateTime: DateTime(2023, 6, 13, 19, 5),
      venue: const VenueEntity(
        id: 64,
        name: 'T-Mobile Park',
        city: 'Seattle',
        state: 'WA',
        country: 'US',
        address: '1516 First Avenue S',
      ),
      performers: [
        const PerformerEntity(
          id: 9,
          name: 'Seattle Mariners',
          type: 'mlb',
          image: 'https://seatgeek.com/images/performers/9/huge.jpg',
        ),
        const PerformerEntity(
          id: 28,
          name: 'Texas Rangers',
          type: 'mlb',
          image: 'https://seatgeek.com/images/performers/28/huge.jpg',
        ),
      ],
      url: 'https://seatgeek.com/rangers-at-mariners-tickets',
      score: 0.826,
      isFavorite: false,
    ),
    EventEntity(
      id: 5183270,
      title: 'Texas Rangers at Oakland Athletics',
      type: 'mlb',
      dateTime: DateTime(2023, 6, 15, 19, 5),
      venue: const VenueEntity(
        id: 65,
        name: 'Oakland Coliseum',
        city: 'Oakland',
        state: 'CA',
        country: 'US',
        address: '7000 Coliseum Way',
      ),
      performers: [
        const PerformerEntity(
          id: 10,
          name: 'Oakland Athletics',
          type: 'mlb',
          image: 'https://seatgeek.com/images/performers/10/huge.jpg',
        ),
        const PerformerEntity(
          id: 28,
          name: 'Texas Rangers',
          type: 'mlb',
          image: 'https://seatgeek.com/images/performers/28/huge.jpg',
        ),
      ],
      url: 'https://seatgeek.com/rangers-at-athletics-tickets',
      score: 0.815,
      isFavorite: true,
    ),
    EventEntity(
      id: 5183271,
      title: 'Texas Rangers at St. Louis Cardinals',
      type: 'mlb',
      dateTime: DateTime(2023, 6, 18, 13, 15),
      venue: const VenueEntity(
        id: 66,
        name: 'Busch Stadium',
        city: 'St. Louis',
        state: 'MO',
        country: 'US',
        address: '700 Clark Avenue',
      ),
      performers: [
        const PerformerEntity(
          id: 11,
          name: 'St. Louis Cardinals',
          type: 'mlb',
          image: 'https://seatgeek.com/images/performers/11/huge.jpg',
        ),
        const PerformerEntity(
          id: 28,
          name: 'Texas Rangers',
          type: 'mlb',
          image: 'https://seatgeek.com/images/performers/28/huge.jpg',
        ),
      ],
      url: 'https://seatgeek.com/rangers-at-cardinals-tickets',
      score: 0.804,
      isFavorite: false,
    ),
  ];

  // Simulate network delay
  final Duration _delay;
  
  // Control whether to simulate errors
  final bool _shouldFail;

  MockEventsRepository({
    Duration? delay,
    bool shouldFail = false,
  }) : _delay = delay ?? const Duration(milliseconds: 500),
       _shouldFail = shouldFail {
    // Initialize favorite
    _favoriteIds.add(5183270); // Make second event favorit by default
    
    /// Set isFavorite flag based on favoriteIds
    _updateFavoriteFlags();
  }

  void _updateFavoriteFlags() {
    for (final event in _mockEvents) {
      event.isFavorite = _favoriteIds.contains(event.id);
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> searchEvents(String query) async {
    await Future.delayed(_delay); // Simulate network delay
    
    if (_shouldFail) {
      return const Left(ServerFailure('Server error occurred'));
    }
    
    if (query.isEmpty) {
      return const Right([]);
    }
    
    // Add to search history
    if (!_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
    }
    
    // Filter events by query (case insensitive)
    final lowercaseQuery = query.toLowerCase();
    final results = _mockEvents.where((event) => 
      event.title.toLowerCase().contains(lowercaseQuery) ||
      event.venue.city.toLowerCase().contains(lowercaseQuery) ||
      event.venue.state.toLowerCase().contains(lowercaseQuery) ||
      event.performers.any((p) => p.name.toLowerCase().contains(lowercaseQuery))
    ).toList();
    
    return Right(results);
  }

  @override
  Future<Either<Failure, List<int>>> getFavoriteEventIds() async {
    await Future.delayed(_delay ~/ 2); // Faster than network
    
    if (_shouldFail) {
      return const Left(CacheFailure('Failed to get favorites'));
    }
    
    return Right(_favoriteIds.toList());
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(int eventId) async {
    await Future.delayed(_delay ~/ 2); // Faster than network
    
    if (_shouldFail) {
      return const Left(CacheFailure('Failed to toggle favorite'));
    }
    
    if (_favoriteIds.contains(eventId)) {
      _favoriteIds.remove(eventId);
    } else {
      _favoriteIds.add(eventId);
    }
    
    // Update isFavorite flags in events
    _updateFavoriteFlags();
    
    return const Right(null);
  }

  @override
  Future<Either<Failure, List<String>>> getSearchHistory() async {
    await Future.delayed(_delay ~/ 2); // Faster than network
    
    if (_shouldFail) {
      return const Left(CacheFailure('Failed to get search history'));
    }
    
    return Right(_searchHistory.toList());
  }
}