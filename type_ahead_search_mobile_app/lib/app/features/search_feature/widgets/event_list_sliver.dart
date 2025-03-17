import 'package:flutter/material.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/features/search_feature/widgets/event_list_item.dart';

class EventListSliver extends StatelessWidget {
  final List<EventEntity> events;
  final Function(EventEntity) onEventTap;
  
  const EventListSliver({
    Key? key,
    required this.events,
    required this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8.0),
      sliver: SliverList(
        // Use delegate with automatic keeping alive
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final event = events[index];
            // Use ObjectKey to maintain state when list is updated
            return EventListItem(
              key: ObjectKey(event),
              event: event,
              onTap: () => onEventTap(event),
            );
          },
          childCount: events.length,
          addAutomaticKeepAlives: true,
        ),
      ),
    );
  }
}


