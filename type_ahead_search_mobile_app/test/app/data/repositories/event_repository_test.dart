

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:type_ahead_search_mobile_app/app/core/constants/api_constants.dart';
import 'package:type_ahead_search_mobile_app/app/core/errors/failure.dart';
import 'package:type_ahead_search_mobile_app/app/data/repositories/mock_events_repository.dart';

void main() {
  late MockEventsRepository repository;

  setUp(() {

    repository = MockEventsRepository(delay: const Duration(milliseconds: 10));
  });

  group('searchEvents', () {
    test('should return empty list for empty query', () async {
 
      final result = await repository.searchEvents('');
      
      
      expect(result, const Right<Failure, List>([]));
    });

    test('should return filtered results for "Texas" query', () async {

      final result = await repository.searchEvents('Texas');
      

      expect(result.isRight(), true);
      final events = result.getOrElse(() => []);
      
      // All events should contain "exas"
      expect(events.length, 3);
      for (final event in events) {
        expect(
          event.title.contains('Texas') || 
          event.performers.any((p) => p.name.contains('Texas')), 
          true
        );
      }
    });

    test('should return filtered results for "Oakland" query', () async {

      final result = await repository.searchEvents('Oakland');
      
  
      expect(result.isRight(), true);
      final events = result.getOrElse(() => []);
      
      // Only Oakland event should be returned
      expect(events.length, 1);
      expect(events[0].venue.city, 'Oakland');
    });
    
    test('should return failure when repository fails', () async {
      // Arrange
      final failingRepo = MockEventsRepository(
        delay: const Duration(milliseconds: 10),
        shouldFail: true,
      );
      
      // Act
      final result = await failingRepo.searchEvents('Texas');
      

      expect(result.isLeft(), true);
      expect(result, const Left<Failure, List>(ServerFailure('Server error occurred')));
    });
  });

  group('toggleFavorite', () {
    test('should toggle favorite status of an event', () async {
      // Arrange - Get initial favorite status
      final initialFavoritesResult = await repository.getFavoriteEventIds();
      final initialFavorites = initialFavoritesResult.getOrElse(() => []);
      const testEventId = 5183269; // First event ID
      

      expect(initialFavorites.contains(testEventId), false);
      

      await repository.toggleFavorite(testEventId);
      
      // Assert 1
    

  
      await repository.toggleFavorite(testEventId);
      

      final afterToggleResult = await repository.getFavoriteEventIds();
      final afterToggleFavorites = afterToggleResult.getOrElse(() => []);
      expect(afterToggleFavorites.contains(testEventId), true);
      
      // Act 2 - Toggle again to unfavorite
      await repository.toggleFavorite(testEventId);
      
      // Assert 2
      final finalResult = await repository.getFavoriteEventIds();
      final finalFavorites = finalResult.getOrElse(() => []);
      expect(finalFavorites.contains(testEventId), false);
    });
    
    test('should return failure when repository fails', () async {
      // Arrange
      final failingRepo = MockEventsRepository(
        delay: const Duration(milliseconds: 10),
        shouldFail: true,
      );
      
      // Act
      final result = await failingRepo.toggleFavorite(5183269);
      

      expect(result.isLeft(), true);
      expect(result, const Left<Failure, void>(CacheFailure('Failed to toggle favorite')));
    });
  });

  group('getFavoriteEventIds', () {
    test('should return list of favorite event IDs', () async {
      // Act
      final result = await repository.getFavoriteEventIds();
      
      // Assert
      expect(result.isRight(), true);
      final favorites = result.getOrElse(() => []);
      expect(favorites, contains(5183270)); // Second event is favorite by default
    });
  });

  group('getSearchHistory', () {
    test('should add to search history when searching', () async {
      // Arrange
      final testQuery = 'test_query_${DateTime.now().millisecondsSinceEpoch}';
      

      await repository.searchEvents(testQuery);
      
      // Act 2 - Get search history
      final result = await repository.getSearchHistory();
      
      // Assert
      expect(result.isRight(), true);
      final history = result.getOrElse(() => []);
      expect(history.contains(testQuery), true);
      // Recent searches should be at the beginning
      expect(history.first, testQuery);
    });
  });
}