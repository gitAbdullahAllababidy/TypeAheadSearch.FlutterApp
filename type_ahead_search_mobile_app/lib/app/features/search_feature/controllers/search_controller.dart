import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/core/utils/debouncer.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/domain/repositories/events_repository.dart';

class TypeAheadSearchController extends GetxController {
  final EventsRepository _eventsRepository;
  final searchTextController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 300);
  
  TypeAheadSearchController({required EventsRepository eventsRepository})
      : _eventsRepository = eventsRepository;

  // Observable variables - use more granular reactive states
  final RxList<EventEntity> events = <EventEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> searchHistory = <String>[].obs;
  final RxBool showSuggestions = false.obs;
  
  // Workers to prevent unnecessary rebuilds
  late Worker _searchHistoryWorker;
  late Worker _eventsLoadingWorker;
  
  @override
  void onInit() {
    super.onInit();
    // Listen to text changes
    searchTextController.addListener(_onSearchChanged);
    
    // Load search history only once at init
    _loadSearchHistory();
    
    // Setup workers to minimize rebuilds
    _setupWorkers();
  }
  
  void _setupWorkers() {
    // Only update search history UI when it actually changes
    _searchHistoryWorker = ever(searchHistory, (_) => update(['search_history']));
    
    // Show loading indicator only when loading state changes
    _eventsLoadingWorker = ever(isLoading, (_) => update(['loading_state']));
  }
  
  Future<void> _loadSearchHistory() async {
    final result = await _eventsRepository.getSearchHistory();
    result.fold(
      (failure) => print('Error loading search history: ${failure.message}'),
      (history) => searchHistory.assignAll(history),
    );
  }
  
  @override
  void onClose() {
    // Clean up resources
    searchTextController.removeListener(_onSearchChanged);
    searchTextController.dispose();
    _debouncer.dispose();
    _searchHistoryWorker.dispose();
    _eventsLoadingWorker.dispose();
    super.onClose();
  }
  
  void _onSearchChanged() {
    if (searchTextController.text.isNotEmpty) {
      showSuggestions.value = true;
    } else {
      showSuggestions.value = false;
      events.clear();
      return;
    }
    
    // Debounce the actual search request
    _debouncer.run(() {
      if (searchTextController.text.isNotEmpty) {
        searchEvents(searchTextController.text);
      } else {
        events.clear();
      }
    });
  }
  
  Future<void> searchEvents(String query) async {
    if (query.isEmpty) return;
    
    errorMessage.value = '';
    isLoading.value = true;
    
    final result = await _eventsRepository.searchEvents(query);
    
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        events.clear();
      },
      (eventsList) {
        // Use assignAll to minimize rebuilds (single update)
        events.assignAll(eventsList);
        // Refresh history after successful search
        _loadSearchHistory();
      },
    );
    
    isLoading.value = false;
  }
  
  void clearSearch() {
    searchTextController.clear();
    events.clear();
    showSuggestions.value = false;
  }
  
  void selectSuggestion(String suggestion) {
    searchTextController.text = suggestion;
    searchTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    searchEvents(suggestion);
    showSuggestions.value = false;
  }
  
  void navigateToDetails(EventEntity event) {
    Get.toNamed('/details', arguments: event);
  }
  
  void toggleFavoriteInList(int eventId, bool isFavorite) {
    // Update event in list without triggering a full rebuild
    final index = events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      events[index].isFavorite = isFavorite;
      // Use refresh instead of update to only update this specific item
      events.refresh();
    }
  }
}