# SeatGeek Event Finder App


## Features

- **Type-ahead Search with Suggestions**: Real-time search results and suggestions as you type
- **In-memory Search Caching**: Cached search results for faster repeat searches
- **Smart Suggestions**: Displays previous searches
- **Favorites Func**: Mark events as favorites with persistent storage
- **Detailed Event Information**: View of event details
- **Optimized UI Performance**: Minimized rebuilds and efficient rendering



### Search Screen


The search screen features:
- Custom app bar with dynamic search field
- Type-ahead suggestions from search history
- Real-time results list with optimized rendering
- Event cards with image, title, venue, date and favorite status

### Details Screen


The details screen displays:
- Hero animation for smooth transitions
- Event header with favorite toggle
- Event image with parallax effect
- Comprehensive event details

## Architecture

This project follows a clean architecture with GetX for state management:

```
lib/
├── app/
│   ├── core/              # Core utilities and constants
│   ├── data/              # Data layer (repositories, models)
│   ├── domain/            # Domain layer (entities, use cases)
│   ├── modules/           # Feature modules
│   │   ├── search/        # Search module with type-ahead functionality
│   │   └── details/       # Details screen module
│   ├── routes/            # Navigation routes
│   ├── services/          # App services
│   │   ├── storage/       # Storage delegates (Facade pattern)
│   │   └── connectivity/  # Network connectivity monitoring
│   └── shared/            # Shared UI components
```

## Suggestions & Search Results Caching

### Suggestions
The app provides smart suggestions to users as they type:

- **Search History Based**: Shows the user's previous searches
- **Real-time Filtering**: Filters suggestions as the user types



### In-memory Search Results Caching
To optimize performance and reduce network requests:

- **Cache by Query**: Results are cached using the search query as the key
- **Instant Retrieval**: Repeat searches load from cache first
- **LRU Implementation**: Least Recently Used cache strategy
- **Smart Invalidation**: Cache is selectively updated when favorites change

## UI Optimization

### Minimizing Rebuilds

The app implements several techniques to minimize unnecessary widget rebuilds:

1. **Granular Reactive State**
   ```dart
   final RxList<Event> events = <Event>[].obs;
   final RxBool isLoading = false.obs;
   final RxString errorMessage = ''.obs;
   ```

2. **Component-Level Updates**
   ```dart
   // Update only the favorite status without rebuilding the entire list
   events[index].isFavorite = newValue;
   events.refresh(); // Updates only what changed
   ```

3. **Proper Use of GetX Tools**
   ```dart
   // GetBuilder with IDs for targeted rebuilds
   GetBuilder<TypeAheadSearchController>(
     id: 'search_text', 
     builder: (_) => /* Widget */,
   )
   ```



## Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/seatgeek_events.git
   cd seatgeek_events
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Update SeatGeek API Client ID
   ```dart
   // In lib/app/core/constants/api_constants.dart
   static const String clientId = 'YOUR_CLIENT_ID';
   ```

4. Run the app
   ```bash
   flutter run
   ```

## Testing

The project includes comprehensive test coverage:

- **Unit tests**: Repository and controller tests


Run tests with:
```bash
# Unit and widget tests
flutter test

# Integration tests
flutter test integration_test/app_test.dart
```


