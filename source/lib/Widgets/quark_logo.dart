// lib/views/common_widgets/quark_logo.dart

import 'package:flutter/material.dart';

class QuarkLogo extends StatelessWidget {
  final double radius;

  const QuarkLogo({
    super.key,
    this.radius = 100, // Default radius, can be overridden
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Big outer circle
        Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
        // Small inner circle using the theme's primary color
        Container(
          width: radius / 2, // Half the size of the outer circle
          height: radius / 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}