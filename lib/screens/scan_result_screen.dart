import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/scan_provider.dart';
import '../providers/history_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/helpers.dart';
import '../widgets/animated_food_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/food_image_widget.dart';
import '../widgets/safety_status_card.dart';
import '../widgets/section_background_card.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    final food = scanProvider.currentFood;
    final imagePath = scanProvider.currentImagePath;

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
                  text: 'Scan Food Now',
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.scan),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayImage = (imagePath != null && imagePath.isNotEmpty) ? imagePath : food.image;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.analytics_rounded, size: 22, color: Colors.white),
            SizedBox(width: 8),
            Text('Scan Result', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
            tooltip: 'Scan Another Item',
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.scan),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_add_rounded, color: Colors.white),
            tooltip: 'Save Result',
            onPressed: () async {
              await scanProvider.saveCurrentScan();
              historyProvider.loadScans();
              if (!context.mounted) return;
              Helpers.showSnackBar(context, 'Scan result saved to history!');
            },
          ),
        ],
      ),
      body: AnimatedFoodBackground(
        backgroundImage: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=1000&q=80',
        imageOpacity: 0.28,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FoodImageWidget(
                imagePath: displayImage,
                width: double.infinity,
                height: 220,
                borderRadius: BorderRadius.circular(24),
              ),
              const SizedBox(height: 20),

              SectionBackgroundCard(
                bgImageUrl: AppImages.vegetablesBg,
                imageOpacity: 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.lightGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.restaurant_rounded, color: AppColors.primaryGreen, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  food.name,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Category: ${food.category}',
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SectionBackgroundCard(
                bgImageUrl: AppImages.safetyScannerBg,
                imageOpacity: 0.15,
                padding: const EdgeInsets.all(12),
                child: SafetyStatusCard(
                  status: food.safetyStatus,
                  recommendation: food.recommendation,
                ),
              ),

              SectionBackgroundCard(
                bgImageUrl: AppImages.superfoodsBg,
                title: 'Nutrition Information',
                icon: Icons.pie_chart_rounded,
                iconColor: AppColors.primaryGreen,
                imageOpacity: 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, size: 14, color: AppColors.primaryGreen),
                          SizedBox(width: 6),
                          Text(
                            'Approximate nutritional values per 100g',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _buildNutrientChip(
                            'Calories',
                            '${food.calories.toInt()} kcal',
                            Icons.local_fire_department_rounded,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNutrientChip(
                            'Protein',
                            '${food.protein} g',
                            Icons.fitness_center_rounded,
                            AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNutrientChip(
                            'Carbs',
                            '${food.carbohydrates} g',
                            Icons.grain_rounded,
                            Colors.amber.shade800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNutrientChip(
                            'Fat',
                            '${food.fat} g',
                            Icons.water_drop_rounded,
                            Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNutrientChip(
                            'Fiber',
                            '${food.fiber} g',
                            Icons.eco_rounded,
                            AppColors.secondaryGreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNutrientChip(
                            'Sugar',
                            '${food.sugar} g',
                            Icons.cake_rounded,
                            Colors.purple,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildNutrientChip(
                            'Sodium',
                            '${food.sodium.toInt()} mg',
                            Icons.opacity_rounded,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SectionBackgroundCard(
                bgImageUrl: AppImages.healthyBowlBg,
                title: 'Health Benefits',
                icon: Icons.health_and_safety_rounded,
                iconColor: AppColors.primaryGreen,
                imageOpacity: 0.15,
                child: Column(
                  children: food.healthBenefits
                      .map((benefit) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primaryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),

              if (food.allergens.isNotEmpty)
                SectionBackgroundCard(
                  bgImageUrl: AppImages.alertsWarningBg,
                  title: 'Allergens Warning',
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.orange,
                  borderColor: Colors.orange.withValues(alpha: 0.3),
                  imageOpacity: 0.15,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: food.allergens
                        .map((all) => Chip(
                              avatar: const Icon(Icons.warning_rounded, size: 14, color: Colors.orange),
                              label: Text(all),
                              backgroundColor: Colors.amber.shade100,
                              labelStyle: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
                            ))
                        .toList(),
                  ),
                ),

              Column(
                children: [
                  CustomButton(
                    text: 'Scan Another Item',
                    icon: Icons.qr_code_scanner_rounded,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.scan);
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await scanProvider.saveCurrentScan();
                        historyProvider.loadScans();
                        if (!context.mounted) return;
                        Helpers.showSnackBar(context, 'Scan result saved to history!');
                      },
                      icon: const Icon(Icons.bookmark_add_rounded, color: AppColors.primaryGreen),
                      label: const Text('Save to Scan History', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientChip(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
