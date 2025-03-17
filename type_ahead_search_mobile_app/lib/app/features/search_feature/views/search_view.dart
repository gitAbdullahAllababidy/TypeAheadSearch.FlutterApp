import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/widgets/event_list_item.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/widgets/search_app_bar.dart';

import '../controllers/search_controller.dart';


class SearchView extends GetView<TypeAheadSearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a focus node to track search focus state
    final searchFocusNode = FocusNode();
    
    // Listen for focus changes
    searchFocusNode.addListener(() {
      controller.showSuggestions.value = searchFocusNode.hasFocus;
    });
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom search bar matching the design
            SearchBarWidget(
              controller: controller.searchTextController,
              focusNode: searchFocusNode,
              onClear: controller.clearSearch,
              onSubmitted: (value) {
                searchFocusNode.unfocus();
                controller.searchEvents(value);
                controller.showSuggestions.value = false;
              },
            ),
            
            // Loading indicator
            Obx(() => controller.isLoading.value 
              ? const LinearProgressIndicator() 
              : const SizedBox(height: 1)
            ),
            
            // Results list
            Expanded(
              child: Obx(() {
                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text('Error: ${controller.errorMessage.value}'),
                  );
                }
                
                if (controller.events.isEmpty && 
                    controller.searchTextController.text.isNotEmpty &&
                    !controller.isLoading.value) {
                  return const Center(
                    child: Text('No events found'),
                  );
                }
                
                return ListView.separated(
                  itemCount: controller.events.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final event = controller.events[index];
                    return EventListItem(
                      key: ValueKey('event_${event.id}'),
                      event: event,
                      onTap: () => controller.navigateToDetails(event),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }


}