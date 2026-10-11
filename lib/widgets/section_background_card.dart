import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SectionBackgroundCard extends StatelessWidget {
  final Widget child;
  final String bgImageUrl;
  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final double imageOpacity;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;

  const SectionBackgroundCard({
    super.key,
    required this.child,
    required this.bgImageUrl,
    this.title,
    this.icon,
    this.iconColor,
    this.trailing,
    this.imageOpacity = 0.12,
    this.margin,
    this.padding,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard.withValues(alpha: 0.92) : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor ?? AppColors.primaryGreen.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: imageOpacity,
                child: Image.network(
                  bgImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),
            Padding(
              padding: padding ?? const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (icon != null) ...[
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: (iconColor ?? AppColors.primaryGreen).withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(icon, color: iconColor ?? AppColors.primaryGreen, size: 18),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              title!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        ...?trailing != null ? [trailing!] : null,
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
