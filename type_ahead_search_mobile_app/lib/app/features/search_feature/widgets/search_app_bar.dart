import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onSubmitted,
    this.onClear,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF1A2639),
        boxShadow: [
        
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
             
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.search,
                
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  hintText: 'Search events...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  
                  suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.remove_circle_outline_sharp, color: Colors.grey),
                        onPressed: onClear,
                      )
                    : null,
                ),
              ),
            ),
          ),
          
          // Cancel button (matches design)
          if (focusNode?.hasFocus ?? false)
            TextButton(
              onPressed: () {
                focusNode?.unfocus();
                if (onClear != null) onClear!();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
