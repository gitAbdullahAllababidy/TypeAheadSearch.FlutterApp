import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static const String favoritesKey = 'favorites';
  static const String searchHistoryKey = 'search_history';
  static const int maxSearchHistoryItems = 10;
  
  final GetStorage _storage;

  StorageService({required GetStorage storage}) : _storage = storage;

  static Future<StorageService> init() async {
    await GetStorage.init();
    return StorageService(storage: GetStorage());
  }

  List<int> getFavorites() {
    final favorites = _storage.read<List>(favoritesKey) ?? [];
    return favorites.map<int>((item) => item as int).toList();
  }

  Future<void> toggleFavorite(int eventId) async {
    final favorites = getFavorites();
    
    if (favorites.contains(eventId)) {
      favorites.remove(eventId);
    } else {
      favorites.add(eventId);
    }
    
    await _storage.write(favoritesKey, favorites);
  }

  bool isFavorite(int eventId) {
    final favorites = _storage.read<List>(favoritesKey) ?? [];
    return favorites.contains(eventId);
  }

  // Search history methods
  List<String> getSearchHistory() {
    final history = _storage.read<List>(searchHistoryKey) ?? [];
    return history.map<String>((item) => item as String).toList();
  }

  Future<void> addToSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    final history = getSearchHistory();
    
    // Remove if already exists (to move it to the top)
    history.remove(query);
    
    // Add to the beginning of the list
    history.insert(0, query);
    
    // Limit the size of history
    if (history.length > maxSearchHistoryItems) {
      history.removeLast();
    }
    
    await _storage.write(searchHistoryKey, history);
  }

  Future<void> clearSearchHistory() async {
    await _storage.write(searchHistoryKey, []);
  }
}





