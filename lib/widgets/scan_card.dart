import 'package:flutter/material.dart';
import '../models/scan_model.dart';
import '../utils/app_colors.dart';
import '../utils/helpers.dart';

class ScanCard extends StatelessWidget {
  final ScanModel scan;
  final VoidCallback onTap;

  const ScanCard({super.key, required this.scan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.primaryGreen;
    if (scan.food.status == 'WARNING') statusColor = AppColors.warning;
    if (scan.food.status == 'UNSAFE') statusColor = AppColors.danger;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  scan.food.imageUrl,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 65,
                    height: 65,
                    color: AppColors.lightGreen,
                    child: const Icon(Icons.qr_code_scanner, color: AppColors.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scan.food.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Helpers.formatDate(scan.timestamp),
                      style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Calories: ${scan.food.nutrition.calories.toInt()} kcal',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      scan.food.status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.secondaryText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
