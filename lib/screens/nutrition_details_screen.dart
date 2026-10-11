import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/nutrition_card.dart';

class NutritionDetailsScreen extends StatelessWidget {
  const NutritionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final food = scanProvider.currentFood;
    final nut = food?.nutrition;

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (food != null) ...[
              Text(
                food.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Comprehensive Nutritional Breakdown & Daily Recommendations',
                style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 20),
            ],
            NutritionCard(
              title: 'Calories',
              value: '${nut?.calories.toInt() ?? 95} kcal',
              icon: Icons.local_fire_department,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            NutritionCard(
              title: 'Protein',
              value: '${nut?.protein ?? 0.5} g',
              icon: Icons.fitness_center,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            NutritionCard(
              title: 'Carbohydrates',
              value: '${nut?.carbohydrates ?? 25.0} g',
              icon: Icons.grain,
              color: Colors.amber,
            ),
            const SizedBox(height: 12),
            NutritionCard(
              title: 'Total Fat',
              value: '${nut?.fat ?? 0.3} g',
              icon: Icons.oil_barrel,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            NutritionCard(
              title: 'Dietary Fiber',
              value: '${nut?.fiber ?? 4.4} g',
              icon: Icons.eco,
              color: AppColors.secondaryGreen,
            ),
            const SizedBox(height: 12),
            NutritionCard(
              title: 'Sugars',
              value: '${nut?.sugar ?? 19.0} g',
              icon: Icons.cake,
              color: Colors.purple,
            ),
            const SizedBox(height: 12),
            NutritionCard(
              title: 'Sodium',
              value: '${nut?.sodium ?? 2.0} mg',
              icon: Icons.water_drop,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),

            // Health Considerations & Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primaryGreen),
                      SizedBox(width: 8),
                      Text(
                        'Health & Informational Disclaimer',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nutrition information is informational and depends on the accuracy of available food data. Always consult a qualified healthcare provider or nutritionist for personalized dietary advice.',
                    style: TextStyle(fontSize: 13, color: AppColors.primaryText, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
