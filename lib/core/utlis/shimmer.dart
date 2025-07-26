import 'package:flutter/material.dart';

import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        itemCount: 9, // Adjust the count based on your needs
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(height: 50, width: 200, color: Colors.grey),
          );
        },
      ),
    );
  }
}
