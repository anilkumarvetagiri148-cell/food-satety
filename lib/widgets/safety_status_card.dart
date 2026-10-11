import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SafetyStatusCard extends StatelessWidget {
  final String status;
  final String recommendation;

  const SafetyStatusCard({super.key, required this.status, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.primaryGreen;
    IconData icon = Icons.check_circle;
    String title = 'SAFE TO CONSUME';

    if (status == 'WARNING') {
      color = AppColors.warning;
      icon = Icons.warning_amber_rounded;
      title = 'CONSUME WITH CAUTION';
    } else if (status == 'UNSAFE') {
      color = AppColors.danger;
      icon = Icons.cancel;
      title = 'UNSAFE - DO NOT CONSUME';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recommendation,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}
