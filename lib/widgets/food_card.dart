import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../utils/app_colors.dart';

class FoodCard extends StatelessWidget {
  final FoodModel food;
  final VoidCallback onTap;

  const FoodCard({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.primaryGreen;
    if (food.status == 'WARNING') statusColor = AppColors.warning;
    if (food.status == 'UNSAFE') statusColor = AppColors.danger;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  food.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.lightGreen,
                    child: const Icon(Icons.fastfood, color: AppColors.primaryGreen),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Expires: ${food.expiryDate}',
                      style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  food.status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
