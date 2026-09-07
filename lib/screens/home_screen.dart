import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../providers/alert_provider.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/food_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);

    final user = authProvider.user;
    final userName = user?.name ?? 'Anil';
    final scans = historyProvider.allScans;

    final safeCount = scans.where((s) => s.food.status == 'SAFE').length + (user?.safeScans ?? 8);
    final warningCount = scans.where((s) => s.food.status == 'WARNING').length + (user?.warningScans ?? 3);
    final unsafeCount = scans.where((s) => s.food.status == 'UNSAFE').length + (user?.unsafeScans ?? 1);
    final totalCount = safeCount + warningCount + unsafeCount;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.lightGreen,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                          style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning,',
                            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                          ),
                          Text(
                            '$userName 👋',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, size: 26),
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.alerts),
                      ),
                      if (alertProvider.unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              TextField(
                readOnly: true,
                onTap: () => Navigator.pushNamed(context, AppRoutes.scan),
                decoration: InputDecoration(
                  hintText: "Know what's in your food...",
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                  suffixIcon: const Icon(Icons.qr_code_scanner, color: AppColors.primaryGreen),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Large Scan Button Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.secondaryGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scan. Analyze. Eat Safe.',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check ingredients, allergens & nutrition instantly using your camera.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt),
                          SizedBox(width: 8),
                          Text('Scan Food Now', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Grid
              const Text(
                'Safety Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Total Scans', '$totalCount', Icons.analytics, AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Safe Foods', '$safeCount', Icons.check_circle, AppColors.primaryGreen),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard('Warnings', '$warningCount', Icons.warning, AppColors.warning),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Unsafe Foods', '$unsafeCount', Icons.cancel, AppColors.danger),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Scans Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Scans',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
                    child: const Text('View All', style: TextStyle(color: AppColors.primaryGreen)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (scans.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('No scans yet. Start scanning your food!', style: TextStyle(color: AppColors.secondaryText)),
                  ),
                )
              else
                ...scans.take(3).map((scan) => FoodCard(
                      food: scan.food,
                      onTap: () {
                        scanProvider.analyzeFood(scan.food.name, scan.localImagePath);
                        Navigator.pushNamed(context, AppRoutes.scanResult);
                      },
                    )),
            ],
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

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
