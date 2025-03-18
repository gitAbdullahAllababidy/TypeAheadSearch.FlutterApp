# SeatGeek Event Finder App

## Features

- **Type-ahead search**: Real-time search results as you type
- **Event listings**: Clean, efficient list of events with essential details
- **Event details**: Comprehensive view of event information
- **Favorites**: Mark events as favorites with persistent storage
- **Optimized performance**: Minimized rebuilds and efficient UI rendering

## Simple UI Demonstration

### Search Screen


The search screen features:
- Custom app bar with search field
- Real-time results list
- Event cards with image, title, venue, date and favorite status

### Details Screen


The details screen displays:
- Hero animation for smooth transitions
- Event header with favorite toggle
- Event image with parallax effect
- Event details (date, venue, performers)

## Architecture

This project follows a clean architecture with GetX for state management:

```
lib/
├── app/
│   ├── core/              # Core utilities and constants
│   ├── data/              # Data layer (repositories, models)
│   ├── domain/            # Domain layer (entities, use cases)
│   ├── modules/           # Feature modules
│   ├── routes/            # Navigation routes
│   ├── services/          # App services
│   └── shared/            # Shared UI components
├── test/                  # Unit and widget tests
└── integration_test/      # End-to-end tests
```

## UI Optimization Deep Dive

### Minimizing Rebuilds

The app implements several techniques to minimize unnecessary widget rebuilds:

1. **Granular Reactive State**
   ```dart
   // Instead of one large observable state
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

3. **GetBuilder with IDs**
   ```dart
   GetBuilder<SearchController>(
     id: 'search_text', // Only updates this component when specifically triggered
     builder: (_) => /* Widget */,
   )
   ```


   ```

### Memory Optimization


### Efficient UI Structure

1. **Slivers for Better Scrolling**
   ```dart
   CustomScrollView(
     slivers: [
       SliverAppBar(/* ... */),
       SliverList(/* ... */),
     ],
   )
   ```



3. **AutomaticKeepAliveClientMixin**
   ```dart
   class _EventListItemState extends State<EventListItem> 
       with AutomaticKeepAliveClientMixin {
     // ...
     @override
     bool get wantKeepAlive => true;
   }
   ```

4. **Shared Components**
   ```dart
   // Reusable across the app
   FavoriteButton(
     isFavorite: event.isFavorite,
     onPressed: toggleFavorite,
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


## Testing

The project includes comprehensive test coverage:

- **Unit tests**: Repository and controller tests
- **Widget tests**: UI component tests
- **Integration tests**: End-to-end flow tests

Run tests with:
```bash
# Unit and widget tests
flutter test

# Integration tests
flutter test integration_test/app_test.dart
```
