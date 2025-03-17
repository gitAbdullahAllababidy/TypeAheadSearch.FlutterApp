import 'package:flutter/material.dart';
import 'package:type_ahead_search_mobile_app/app/core/utils/formatters.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/shared/widgets/favorite_indicator.dart';
import 'package:type_ahead_search_mobile_app/app/shared/widgets/optimized_network_image.dart';


class EventListItem extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;

  const EventListItem({
    Key? key, 
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract image from first performer if available
    final imageUrl = event.performers.isNotEmpty && event.performers.first.image != null
        ? event.performers.first.image!
        : '';
    
    // Format date using central formatter
    final formattedDate = Formatters.formatEventDate(event.dateTime);
    final formattedVenue = Formatters.formatVenue(event.venue.city, event.venue.state);
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite indicator using Stack
            Stack(
              children: [
                OptimizedNetworkImage(
                  imageUrl: imageUrl,
                  width: 60,
                  height: 60,
                ),
                if (event.isFavorite)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const FavoriteIndicator(
                        isFavorite: true,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 12),
            
            // Event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedVenue,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




