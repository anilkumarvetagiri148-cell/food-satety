import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../data/food_database.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../providers/alert_provider.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/food_card.dart';
import '../widgets/scan_card.dart';
import '../widgets/animated_food_background.dart';
import '../widgets/healthy_food_showcase.dart';
import '../widgets/circling_food_animation.dart';
import '../widgets/section_background_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<HealthyFoodItem> _homeBannerFoods = const [
    HealthyFoodItem(emoji: '🥦', name: 'Veg', category: 'Vegetables', color: Colors.green),
    HealthyFoodItem(emoji: '🍎', name: 'Fruit', category: 'Fruits', color: Colors.redAccent),
    HealthyFoodItem(emoji: '🥩', name: 'Protein', category: 'Proteins', color: Colors.deepOrange),
    HealthyFoodItem(emoji: '🥜', name: 'Nuts', category: 'Dry Fruits', color: Colors.amber),
    HealthyFoodItem(emoji: '🥕', name: 'Carrot', category: 'Vegetables', color: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);

    final user = authProvider.user;
    final userName = user?.name ?? 'Anil';
    final scans = historyProvider.allScans;

    final totalDatabaseFoods = FoodDatabase.allFoods.length;
    final vegCount = FoodDatabase.getByCategory('Vegetables').length;
    final fruitCount = FoodDatabase.getByCategory('Fruits').length;
    final dryFruitCount = FoodDatabase.getByCategory('Dry Fruits').length;
    final proteinCount = FoodDatabase.getByCategory('High Protein').length;

    final recommendedFoods = [
      FoodDatabase.allFoods[0], // Spinach
      FoodDatabase.allFoods[10], // Apple
      FoodDatabase.allFoods[20], // Almonds
      FoodDatabase.allFoods[30], // Eggs
      FoodDatabase.allFoods[31], // Chicken Breast
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedFoodBackground(
        backgroundImage: AppImages.vegetablesBg,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top User Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.primaryGreen, AppColors.secondaryGreen],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGreen.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                              style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Good Day,',
                                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.verified, size: 14, color: AppColors.primaryGreen),
                              ],
                            ),
                            Text(
                              '$userName 👋',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_active_rounded, size: 22, color: AppColors.primaryGreen),
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.alerts),
                          ),
                          if (alertProvider.unreadCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search Bar Section Card
                SectionBackgroundCard(
                  bgImageUrl: AppImages.fruitsBg,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  imageOpacity: 0.1,
                  child: TextField(
                    readOnly: true,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.scan),
                    decoration: InputDecoration(
                      hintText: "Search 40 foods or scan image...",
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.search_rounded, color: AppColors.primaryGreen),
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.primaryGreen, size: 20),
                      ),
                      filled: false,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),

                // Hero Banner Section Card
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryGreen, AppColors.secondaryGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.38),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Opacity(
                            opacity: 0.15,
                            child: Image.network(
                              AppImages.safetyScannerBg,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.shield_rounded, color: Colors.white, size: 20),
                                    SizedBox(width: 6),
                                    Text(
                                      'FoodSafe AI Scanner',
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Explore 40 Food Database: Vegetables, Fruits, Dry Fruits & High Protein foods!',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
                                  icon: const Icon(Icons.center_focus_strong_rounded, size: 18),
                                  label: const Text('Scan Food', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primaryGreen,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          CirclingFoodAnimation(
                            radius: 38,
                            items: _homeBannerFoods,
                            duration: const Duration(seconds: 10),
                            centerChild: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.restaurant_menu_rounded,
                                size: 22,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Healthy Essentials Rolling Showcase
                SectionBackgroundCard(
                  bgImageUrl: AppImages.healthyBowlBg,
                  imageOpacity: 0.12,
                  child: const HealthyFoodShowcase(),
                ),

                // Food Database Categories Summary
                SectionBackgroundCard(
                  bgImageUrl: AppImages.analyticsBg,
                  title: 'Food Database Overview',
                  icon: Icons.grid_view_rounded,
                  iconColor: AppColors.primaryGreen,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryStatCard('Total Foods', '$totalDatabaseFoods Items', Icons.inventory_2_rounded, AppColors.primaryGreen, isDark),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildCategoryStatCard('Vegetables', '$vegCount Items', Icons.eco_rounded, Colors.green, isDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryStatCard('Fruits', '$fruitCount Items', Icons.apple_rounded, Colors.redAccent, isDark),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildCategoryStatCard('Dry Fruits', '$dryFruitCount Items', Icons.grain_rounded, Colors.amber.shade800, isDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryStatCard('High Protein', '$proteinCount Items', Icons.fitness_center_rounded, Colors.deepOrange, isDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Recommended Foods Section
                SectionBackgroundCard(
                  bgImageUrl: AppImages.superfoodsBg,
                  title: 'Recommended Foods',
                  icon: Icons.thumb_up_alt_rounded,
                  iconColor: AppColors.primaryGreen,
                  trailing: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
                    child: const Text('View All (40)', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                  ),
                  child: Column(
                    children: recommendedFoods.map((food) {
                      return FoodCard(
                        food: food,
                        onTap: () async {
                          final nav = Navigator.of(context);
                          await scanProvider.analyzeFood(null, null, food);
                          if (!mounted) return;
                          nav.pushNamed(AppRoutes.scanResult);
                        },
                      );
                    }).toList(),
                  ),
                ),

                // Recent Scans Section
                SectionBackgroundCard(
                  bgImageUrl: AppImages.labCheckBg,
                  title: 'Recent Scans',
                  icon: Icons.history_rounded,
                  iconColor: AppColors.primaryGreen,
                  trailing: TextButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryGreen),
                    label: const Text('View All', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                  ),
                  child: Column(
                    children: [
                      if (scans.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.15)),
                          ),
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline_rounded, color: AppColors.secondaryText, size: 18),
                                SizedBox(width: 8),
                                Text('No scans yet. Tap "Scan Food" to begin!', style: TextStyle(color: AppColors.secondaryText, fontSize: 13)),
                              ],
                            ),
                          ),
                        )
                      else
                        ...scans.take(3).map((scan) => ScanCard(
                              scan: scan,
                              onTap: () {
                                scanProvider.analyzeFood(scan.food.name, scan.localImagePath);
                                Navigator.pushNamed(context, AppRoutes.scanResult);
                              },
                            )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) Navigator.pushNamed(context, AppRoutes.scan);
          if (index == 2) Navigator.pushNamed(context, AppRoutes.history);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.alerts);
          if (index == 4) Navigator.pushNamed(context, AppRoutes.profile);
        },
      ),
    );
  }

  Widget _buildCategoryStatCard(String title, String count, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
