import 'package:flutter/material.dart';

class EmptyStateSliver extends StatelessWidget {
  const EmptyStateSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Search for events',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
