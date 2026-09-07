import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/scan_provider.dart';
import '../providers/history_provider.dart';
import '../utils/app_colors.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/safety_status_card.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    final food = scanProvider.currentFood;

    if (food == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan Result')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No scan result available.'),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: CustomButton(
                  text: 'Scan Again',
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.scan),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () async {
              await scanProvider.saveCurrentScan();
              historyProvider.loadScans();
              if (!context.mounted) return;
              Helpers.showSnackBar(context, 'Scan result saved successfully!');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                food.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: AppColors.lightGreen,
                  child: const Icon(Icons.fastfood, size: 60, color: AppColors.primaryGreen),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Food Name & Expiry
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    food.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Exp: ${food.expiryDate}',
                    style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Safety Status Card
            SafetyStatusCard(status: food.status, recommendation: food.safetyRecommendation),
            const SizedBox(height: 24),

            // Ingredients
            const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: food.ingredients
                  .map((ing) => Chip(
                        label: Text(ing),
                        backgroundColor: AppColors.lightGreen,
                        labelStyle: const TextStyle(color: AppColors.primaryText, fontSize: 13),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Allergens
            const Text('Allergens', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            food.allergens.isEmpty
                ? const Text('No major allergens detected.', style: TextStyle(color: AppColors.secondaryText))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: food.allergens
                        .map((all) => Chip(
                              label: Text(all),
                              backgroundColor: AppColors.warning.withOpacity(0.2),
                              labelStyle: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 13),
                            ))
                        .toList(),
                  ),
            const SizedBox(height: 24),

            // Nutrition Summary Preview
            const Text('Nutrition Summary (per serving)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.5,
                children: [
                  _buildNutrientItem('Calories', '${food.nutrition.calories.toInt()} kcal'),
                  _buildNutrientItem('Protein', '${food.nutrition.protein}g'),
                  _buildNutrientItem('Carbs', '${food.nutrition.carbohydrates}g'),
                  _buildNutrientItem('Fat', '${food.nutrition.fat}g'),
                  _buildNutrientItem('Sugar', '${food.nutrition.sugar}g'),
                  _buildNutrientItem('Sodium', '${food.nutrition.sodium}mg'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            CustomButton(
              text: 'View Detailed Nutrition',
              icon: Icons.pie_chart,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.nutrition),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await scanProvider.saveCurrentScan();
                      historyProvider.loadScans();
                      if (!context.mounted) return;
                      Helpers.showSnackBar(context, 'Result saved to history!');
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      side: const BorderSide(color: AppColors.primaryGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Result', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.scan),
                    child: const Text('Scan Another'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
      ],
    );
  }
}
