import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/domain/repositories/events_repository.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/controllers/search_controller.dart';

class DetailsController extends GetxController {
  final EventsRepository _eventsRepository;
  
  DetailsController({required EventsRepository eventsRepository})
      : _eventsRepository = eventsRepository;
  
  // Observable variables with more specific Rx types
  final Rx<EventEntity?> event = Rx<EventEntity?>(null);
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Get the event from arguments
    final eventArg = Get.arguments as EventEntity?;
    if (eventArg != null) {
      event.value = eventArg;
    }
  }
  
  Future<void> toggleFavorite() async {
    if (event.value == null) return;
    
    isLoading.value = true;
    
    final result = await _eventsRepository.toggleFavorite(event.value!.id);
    
    result.fold(
      (failure) => print('Error toggling favorite: ${failure.message}'),
      (_) {
        final newFavoriteState = !event.value!.isFavorite;
        
        // Update without triggering a full rebuild
        event.update((val) {
          val?.isFavorite = newFavoriteState;
        });
        
        // Update search controller if it exists
        if (Get.isRegistered<TypeAheadSearchController>()) {
          final typeAheadSearchController = Get.find<TypeAheadSearchController>();
          typeAheadSearchController.toggleFavoriteInList(event.value!.id, newFavoriteState);
        }
      },
    );
    
    isLoading.value = false;
  }
  
  void goBack() {
    Get.back();
  }
}