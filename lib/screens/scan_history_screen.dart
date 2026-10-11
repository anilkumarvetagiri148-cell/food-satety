import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/history_provider.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../widgets/animated_food_background.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/scan_card.dart';
import '../widgets/section_background_card.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  int _currentIndex = 2;
  final List<Map<String, dynamic>> _filters = [
    {'name': 'All', 'icon': Icons.all_inclusive_rounded, 'color': AppColors.primaryGreen},
    {'name': 'Safe', 'icon': Icons.check_circle_rounded, 'color': AppColors.secondaryGreen},
    {'name': 'Warning', 'icon': Icons.warning_amber_rounded, 'color': AppColors.warning},
    {'name': 'Unsafe', 'icon': Icons.cancel_rounded, 'color': AppColors.danger},
  ];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final scans = historyProvider.scans;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.history_edu_rounded, size: 22, color: Colors.white),
            SizedBox(width: 8),
            Text('Scan History', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedFoodBackground(
        backgroundImage: AppImages.historyBg,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionBackgroundCard(
                  bgImageUrl: AppImages.historyBg,
                  title: 'Search & Filter History',
                  icon: Icons.filter_alt_rounded,
                  iconColor: AppColors.primaryGreen,
                  imageOpacity: 0.22,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2)),
                        ),
                        child: TextField(
                          onChanged: (val) => historyProvider.setSearchQuery(val),
                          decoration: const InputDecoration(
                            hintText: 'Search scan history...',
                            prefixIcon: Icon(Icons.search_rounded, color: AppColors.primaryGreen),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _filters.map((filter) {
                            final name = filter['name'] as String;
                            final icon = filter['icon'] as IconData;
                            final color = filter['color'] as Color;
                            final isSelected = _selectedFilter == name;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                avatar: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white : color.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(icon, size: 14, color: isSelected ? color : color),
                                ),
                                label: Text(name),
                                selected: isSelected,
                                selectedColor: color,
                                backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                                side: BorderSide(
                                  color: isSelected ? color : color.withValues(alpha: 0.2),
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primaryText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => _selectedFilter = name);
                                    historyProvider.setFilter(name);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                SectionBackgroundCard(
                  bgImageUrl: AppImages.historyBg,
                  title: 'Scanned Items (${scans.length})',
                  icon: Icons.receipt_long_rounded,
                  iconColor: AppColors.primaryGreen,
                  imageOpacity: 0.18,
                  child: scans.isEmpty
                      ? const EmptyState(
                          title: 'No Scan History',
                          subtitle: 'Your scanned food products will appear here.',
                          icon: Icons.history_rounded,
                        )
                      : Column(
                          children: scans.map((scan) {
                            return ScanCard(
                              scan: scan,
                              onTap: () {
                                scanProvider.analyzeFood(scan.food.name, scan.localImagePath);
                                Navigator.pushNamed(context, AppRoutes.scanResult);
                              },
                            );
                          }).toList(),
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
          if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.home);
          if (index == 1) Navigator.pushNamed(context, AppRoutes.scan);
          if (index == 3) Navigator.pushReplacementNamed(context, AppRoutes.alerts);
          if (index == 4) Navigator.pushReplacementNamed(context, AppRoutes.profile);
        },
      ),
    );
  }
}
