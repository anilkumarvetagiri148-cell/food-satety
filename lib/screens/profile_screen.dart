import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 4; // Profile tab

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final historyProvider = Provider.of<HistoryProvider>(context);

    final user = authProvider.user;
    final userName = user?.name ?? 'Anil';
    final userEmail = user?.email ?? 'anil@example.com';
    final totalScans = historyProvider.allScans.length + (user?.totalScans ?? 12);
    final safeScans = historyProvider.allScans.where((s) => s.food.status == 'SAFE').length + (user?.safeScans ?? 8);
    final warningScans = historyProvider.allScans.where((s) => s.food.status == 'WARNING').length + (user?.warningScans ?? 3);
    final unsafeScans = historyProvider.allScans.where((s) => s.food.status == 'UNSAFE').length + (user?.unsafeScans ?? 1);

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // User Avatar & Info
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.lightGreen,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                        style: const TextStyle(color: AppColors.primaryGreen, fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics Row
              Row(
                children: [
                  Expanded(child: _buildStatBox('Total', '$totalScans', AppColors.primaryGreen)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatBox('Safe', '$safeScans', AppColors.secondaryGreen)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatBox('Warning', '$warningScans', AppColors.warning)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatBox('Unsafe', '$unsafeScans', AppColors.danger)),
                ],
              ),
              const SizedBox(height: 32),

              // Menu Options
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications & Alerts',
                onTap: () => Navigator.pushNamed(context, AppRoutes.alerts),
              ),
              _buildMenuItem(
                icon: Icons.security,
                title: 'Privacy & Security',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Privacy & Security'),
                      content: const Text('All your scans and preferences are securely stored locally on your device offline.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                      ],
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Help & Support'),
                      content: const Text('For assistance with FoodSafe AI, please contact support@foodsafeai.local.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                textColor: AppColors.danger,
                iconColor: AppColors.danger,
                onTap: () async {
                  await authProvider.logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.home);
          if (index == 1) Navigator.pushNamed(context, AppRoutes.scan);
          if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.history);
          if (index == 3) Navigator.pushReplacementNamed(context, AppRoutes.alerts);
        },
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = AppColors.primaryText,
    Color iconColor = AppColors.primaryGreen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.secondaryText),
        onTap: onTap,
      ),
    );
  }
}
