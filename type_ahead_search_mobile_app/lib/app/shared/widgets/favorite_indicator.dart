import 'package:flutter/material.dart';

class FavoriteIndicator extends StatelessWidget {
  final bool isFavorite;
  final double size;
  final Color color;
  
  const FavoriteIndicator({
    Key? key,
    required this.isFavorite,
    this.size = 16.0,
    this.color = Colors.red,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (!isFavorite) return const SizedBox.shrink();
    
    return Icon(
      Icons.favorite,
      color: color,
      size: size,
    );
  }
}