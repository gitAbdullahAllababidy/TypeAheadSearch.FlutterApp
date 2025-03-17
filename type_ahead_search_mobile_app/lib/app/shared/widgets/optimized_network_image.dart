import 'package:flutter/material.dart';

class OptimizedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  
  const OptimizedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final defaultPlaceholder = Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Icon(Icons.event, color: Colors.grey),
    );
    
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        child: defaultPlaceholder,
      );
    }
    
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      child: Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? defaultPlaceholder;
        },
        errorBuilder: (_, __, ___) => errorWidget ?? defaultPlaceholder,
      ),
    );
  }
}