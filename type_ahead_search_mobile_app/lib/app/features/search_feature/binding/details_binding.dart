import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/data/repositories/events_repository_impl.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/controllers/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Register controller
    Get.lazyPut<DetailsController>(
      () => DetailsController(
        eventsRepository: Get.find<EventsRepositoryImpl>(),
      ),
    );
  }
}