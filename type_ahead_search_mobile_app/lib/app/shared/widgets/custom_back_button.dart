import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  
  const CustomBackButton({
    Key? key,
    required this.onPressed,
    this.color = Colors.black,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: color,
        size: 20,
      ),
      onPressed: onPressed,
    );
  }
}
