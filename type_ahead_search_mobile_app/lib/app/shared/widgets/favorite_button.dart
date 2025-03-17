import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final bool isLoading;
  final VoidCallback onPressed;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  
  const FavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onPressed,
    this.isLoading = false,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.grey,
    this.size = 24.0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? activeColor : inactiveColor,
        size: size,
      ),
      onPressed: isLoading ? null : onPressed,
    );
  }
}
