import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/shared/widgets/custom_back_button.dart';
import 'package:type_ahead_search_mobile_app/app/shared/widgets/optimized_network_image.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/favorite_button.dart';
import '../controllers/details_controller.dart';


class DetailsView extends GetView<DetailsController> {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final event = controller.event.value;
        
        if (event == null) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Get main image from first performer if available
        final imageUrl = event.performers.isNotEmpty && event.performers.first.image != null
            ? event.performers.first.image!
            : '';
        
        // Format date using central formatter
        final formattedDate = Formatters.formatEventDetailDate(event.dateTime);
        final formattedVenue = Formatters.formatVenue(event.venue.city, event.venue.state);
        
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom header bar
              _buildHeader(event),
              
              // Event image
              AspectRatio(
                aspectRatio: 16/9,
                child: OptimizedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 240,
                  borderRadius: BorderRadius.zero,
                ),
              ),
              
              // Event details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Venue
                    Text(
                      formattedVenue,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    
                    // Additional details could be added here
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildHeader(EventEntity event) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          CustomBackButton(onPressed: controller.goBack),
          
          // Title
          Expanded(
            child: Text(
              event.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          
          // Favorite button
          Obx(() => FavoriteButton(
            isFavorite: event.isFavorite,
            isLoading: controller.isLoading.value,
            onPressed: controller.toggleFavorite,
          )),
        ],
      ),
    );
  }
}