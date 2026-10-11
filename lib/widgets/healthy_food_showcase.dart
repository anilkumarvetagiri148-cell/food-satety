import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';

class ShowcaseFoodItem {
  final String emoji;
  final String name;
  final String category;
  final String benefit;
  final Color color;

  const ShowcaseFoodItem({
    required this.emoji,
    required this.name,
    required this.category,
    required this.benefit,
    required this.color,
  });
}

const List<ShowcaseFoodItem> kShowcaseFoods = [
  ShowcaseFoodItem(
    emoji: '🍏',
    name: 'Guava',
    category: 'Fruits',
    benefit: '2.6g Protein & 4x Vit C',
    color: Colors.lightGreen,
  ),
  ShowcaseFoodItem(
    emoji: '🫐',
    name: 'Passion Fruit',
    category: 'Fruits',
    benefit: '2.2g Protein & Fiber',
    color: Colors.purple,
  ),
  ShowcaseFoodItem(
    emoji: '🍈',
    name: 'Jackfruit',
    category: 'Fruits',
    benefit: '1.7g Protein & B-Complex',
    color: Colors.amber,
  ),
  ShowcaseFoodItem(
    emoji: '🍎',
    name: 'Pomegranate',
    category: 'Fruits',
    benefit: '1.7g Protein & Antioxidants',
    color: Colors.redAccent,
  ),
  ShowcaseFoodItem(
    emoji: '🥩',
    name: 'Atlantic Salmon',
    category: 'Proteins',
    benefit: '22g Protein & Omega-3',
    color: Colors.deepOrange,
  ),
  ShowcaseFoodItem(
    emoji: '🥚',
    name: 'Organic Eggs',
    category: 'Proteins',
    benefit: '13g Complete Protein & Choline',
    color: Colors.amber,
  ),
  ShowcaseFoodItem(
    emoji: '🥦',
    name: 'Fresh Broccoli',
    category: 'Vegetables',
    benefit: '2.8g Protein & Sulforaphane',
    color: Colors.green,
  ),
  ShowcaseFoodItem(
    emoji: '🥬',
    name: 'Baby Spinach',
    category: 'Vegetables',
    benefit: '2.9g Protein & Bioavailable Iron',
    color: Colors.teal,
  ),
];

class HealthyFoodShowcase extends StatefulWidget {
  const HealthyFoodShowcase({super.key});

  @override
  State<HealthyFoodShowcase> createState() => _HealthyFoodShowcaseState();
}

class _HealthyFoodShowcaseState extends State<HealthyFoodShowcase> {
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;

  final List<String> _categories = const ['All', 'Vegetables', 'Fruits', 'Proteins'];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + 1.2,
            duration: const Duration(milliseconds: 40),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredFoods = _selectedCategory == 'All'
        ? kShowcaseFoods
        : kShowcaseFoods.where((f) => f.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 22),
                SizedBox(width: 8),
                Text(
                  'Healthy Essentials',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
              icon: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryGreen),
              label: const Text('Scan Foods', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Category Filter Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: isDark ? AppColors.darkCard : AppColors.lightGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedCategory = category);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Rolling Horizontal Food Cards
        SizedBox(
          height: 125,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: filteredFoods.length * 5,
            itemBuilder: (context, index) {
              final item = filteredFoods[index % filteredFoods.length];
              return GestureDetector(
                onTap: () async {
                  final nav = Navigator.of(context);
                  final scanProvider = Provider.of<ScanProvider>(context, listen: false);
                  nav.pushNamed(AppRoutes.scanAnalysis);
                  await scanProvider.analyzeFood(item.name);
                  if (!mounted) return;
                  nav.pushReplacementNamed(AppRoutes.scanResult);
                },
                child: Container(
                  width: 175,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: item.color.withValues(alpha: 0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.emoji, style: const TextStyle(fontSize: 26)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.category,
                              style: TextStyle(color: item.color, fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.benefit,
                            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
