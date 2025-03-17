import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/data/providers/api_provider.dart';
import 'package:type_ahead_search_mobile_app/app/data/repositories/events_repository_impl.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Register API provider if not already registered
    if (!Get.isRegistered<ApiProvider>()) {
      Get.put<ApiProvider>(
        ApiProvider(dioService: Get.find()),
        permanent: true,
      );
    }
    
    // Register repository
    Get.lazyPut<EventsRepositoryImpl>(
      () => EventsRepositoryImpl(
        apiProvider: Get.find<ApiProvider>(),
        storageService: Get.find(),
      ),
    );
    
    // Register controller
    Get.lazyPut<TypeAheadSearchController>(
      () => TypeAheadSearchController(
        eventsRepository: Get.find<EventsRepositoryImpl>(),
      ),
    );
  }
}






