

// lib/app/modules/details/views/widgets/parallax_image_header.dart
import 'package:flutter/material.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/event.dart';
import 'package:type_ahead_search_mobile_app/app/domain/entities/performer.dart';


class ParallaxSliverAppBar extends StatefulWidget {
  final EventEntity event;
  final bool isLoading;
  final VoidCallback onBackPressed;
  final VoidCallback onFavoriteToggle;
  
  const ParallaxSliverAppBar({
    Key? key,
    required this.event,
    required this.isLoading,
    required this.onBackPressed,
    required this.onFavoriteToggle,
  }) : super(key: key);
  
  @override
  State<ParallaxSliverAppBar> createState() => _ParallaxSliverAppBarState();
}

class _ParallaxSliverAppBarState extends State<ParallaxSliverAppBar> {
  late String _imageUrl;
  
  @override
  void initState() {
    super.initState();
    _updateImageUrl();
  }
  
  @override
  void didUpdateWidget(ParallaxSliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event != widget.event) {
      _updateImageUrl();
    }
  }
  
  void _updateImageUrl() {
    _imageUrl = widget.event.performers.isNotEmpty && 
                widget.event.performers.first.image != null
        ? widget.event.performers.first.image!
        : '';
  }
  
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      stretch: true,
      leading: IconButton(
        key: const ValueKey('back_button'),
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onBackPressed,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.event.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 4,
                color: Colors.black45,
                offset: Offset(0, 1),
              ),
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero image with parallax effect
            Hero(
              tag: 'event_image_${widget.event.id}',
              child: _imageUrl.isNotEmpty
                ? Image.network(
                    _imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.event,
                      size: 50,
                    ),
                  ),
            ),
            // Gradient overlay for better text visibility
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Only rebuild the favorite button, not the whole app bar
        IconButton(
          key: ValueKey('favorite_${widget.event.id}_${widget.event.isFavorite}'),
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              widget.event.isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(widget.event.isFavorite),
              color: widget.event.isFavorite ? Colors.red : Colors.white,
            ),
          ),
          onPressed: widget.isLoading ? null : widget.onFavoriteToggle,
        ),
      ],
    );
  }
}



class PerformerList extends StatefulWidget {
  final List<PerformerEntity> performers;
  
  const PerformerList({
    Key? key,
    required this.performers,
  }) : super(key: key);
  
  @override
  State<PerformerList> createState() => _PerformerListState();
}

class _PerformerListState extends State<PerformerList> {
  bool _expanded = false;
  
  @override
  Widget build(BuildContext context) {
    // Show first 3 performers by default, all if expanded
    final performers = _expanded 
        ? widget.performers 
        : widget.performers.take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: performers.length,
          itemBuilder: (context, index) {
            return _PerformerListItem(performer: performers[index]);
          },
        ),
        
        // Show "Show More" button if there are more than 3 performers
        if (widget.performers.length > 3)
          TextButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_expanded ? 'Show Less' : 'Show More'),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
      ],
    );
  }
}

class _PerformerListItem extends StatelessWidget {
  final PerformerEntity performer;
  
  const _PerformerListItem({
    Key? key,
    required this.performer,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (performer.image != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                performer.image!,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 32,
                  height: 32,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              performer.name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}