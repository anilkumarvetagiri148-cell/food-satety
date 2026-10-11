import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AnimatedFoodBackground extends StatelessWidget {
  final Widget child;
  final String backgroundImage;
  final double imageOpacity;

  const AnimatedFoodBackground({
    super.key,
    required this.child,
    required this.backgroundImage,
    this.imageOpacity = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base Background Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? const [AppColors.darkBackground, Color(0xFF0F1E16), AppColors.darkBackground]
                  : const [Color(0xFFF4FAF5), Color(0xFFE8F5EB), Color(0xFFF0F9F2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Background Image Overlay
        Positioned.fill(
          child: Opacity(
            opacity: imageOpacity,
            child: Image.network(
              backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
        ),

        // Foreground Content
        child,
      ],
    );
  }
}
