import 'package:flutter/material.dart';
import '../models/scan_model.dart';
import '../utils/app_colors.dart';
import '../utils/helpers.dart';
import 'food_image_widget.dart';

class ScanCard extends StatelessWidget {
  final ScanModel scan;
  final VoidCallback onTap;

  const ScanCard({
    super.key,
    required this.scan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.primaryGreen;
    if (scan.food.safetyStatus == 'WARNING') statusColor = AppColors.warning;
    if (scan.food.safetyStatus == 'UNSAFE') statusColor = AppColors.danger;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imagePath = scan.localImagePath ?? scan.food.image;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              FoodImageWidget(
                imagePath: imagePath,
                width: 68,
                height: 68,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.food.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scan.food.category,
                      style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Helpers.formatDate(scan.timestamp),
                      style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      scan.food.safetyStatus,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
