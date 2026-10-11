import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../widgets/animated_food_background.dart';
import '../widgets/section_background_card.dart';

class EatHealthyScreen extends StatefulWidget {
  const EatHealthyScreen({super.key});

  @override
  State<EatHealthyScreen> createState() => _EatHealthyScreenState();
}

class _EatHealthyScreenState extends State<EatHealthyScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _healthyFoods = [
    {
      'name': 'Organic Spinach',
      'category': 'Vegetables',
      'benefit': 'Iron, Folate & Antioxidants',
      'image': 'assets/images/foods/vegetables/spinach.jpg',
      'color': Colors.green,
    },
    {
      'name': 'Broccoli',
      'category': 'Vegetables',
      'benefit': 'Sulforaphane & Vitamin C',
      'image': 'assets/images/foods/vegetables/broccoli.jpg',
      'color': Colors.teal,
    },
    {
      'name': 'Fresh Apples',
      'category': 'Fruits',
      'benefit': 'Pectin Fiber & Quercetin',
      'image': 'assets/images/foods/fruits/apple.jpg',
      'color': Colors.redAccent,
    },
    {
      'name': 'Bananas',
      'category': 'Fruits',
      'benefit': 'Potassium & B-Vitamins',
      'image': 'assets/images/foods/fruits/banana.jpg',
      'color': Colors.amber,
    },
    {
      'name': 'Raw Almonds',
      'category': 'Dry Fruits',
      'benefit': 'Vitamin E & Healthy Monounsaturated Fats',
      'image': 'assets/images/foods/dry_fruits/almonds.jpg',
      'color': Colors.brown,
    },
    {
      'name': 'Boiled Eggs',
      'category': 'High Protein',
      'benefit': 'Complete Bioavailable Protein & Choline',
      'image': 'assets/images/foods/protein/eggs.jpg',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == 'All'
        ? _healthyFoods
        : _healthyFoods.where((f) => f['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.restaurant_rounded, size: 22, color: Colors.white),
            SizedBox(width: 8),
            Text('Eat Healthy Guide', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedFoodBackground(
        backgroundImage: AppImages.healthyBowlBg,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionBackgroundCard(
                bgImageUrl: AppImages.superfoodsBg,
                title: 'Nutritional Food Showcase',
                icon: Icons.eco_rounded,
                iconColor: AppColors.primaryGreen,
                child: const Text(
                  'Explore nutrient-dense foods carefully categorized for your daily health goals.',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Vegetables', 'Fruits', 'Dry Fruits', 'High Protein'].map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: AppColors.lightGreen,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCategory = cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.restaurant_menu_rounded, color: item['color'] as Color),
                      ),
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item['benefit'], style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primaryGreen),
                      onTap: () async {
                        final nav = Navigator.of(context);
                        final scanProvider = Provider.of<ScanProvider>(context, listen: false);
                        nav.pushNamed(AppRoutes.scanAnalysis);
                        await scanProvider.analyzeFood(item['name']);
                        if (!mounted) return;
                        nav.pushReplacementNamed(AppRoutes.scanResult);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
