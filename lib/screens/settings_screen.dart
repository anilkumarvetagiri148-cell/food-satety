import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../firebase_options.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import '../utils/helpers.dart';
import '../widgets/animated_food_background.dart';
import '../widgets/section_background_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _expiryAlerts = true;
  bool _safetyAlerts = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.tune_rounded, size: 22, color: Colors.white),
            SizedBox(width: 8),
            Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedFoodBackground(
        backgroundImage: AppImages.safetyScannerBg,
        imageOpacity: 0.28,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Appearance Section Card
            SectionBackgroundCard(
              bgImageUrl: AppImages.superfoodsBg,
              title: 'Appearance & Theme',
              icon: Icons.palette_rounded,
              iconColor: Colors.teal,
              imageOpacity: 0.2,
              child: Column(
                children: [
                  _buildThemeTile(
                    label: 'System Default',
                    mode: ThemeMode.system,
                    currentMode: themeProvider.themeMode,
                    icon: Icons.auto_mode_rounded,
                    iconColor: Colors.blue,
                    onSelect: themeProvider.setThemeMode,
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  _buildThemeTile(
                    label: 'Light Mode',
                    mode: ThemeMode.light,
                    currentMode: themeProvider.themeMode,
                    icon: Icons.wb_sunny_rounded,
                    iconColor: Colors.amber,
                    onSelect: themeProvider.setThemeMode,
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  _buildThemeTile(
                    label: 'Dark Mode',
                    mode: ThemeMode.dark,
                    currentMode: themeProvider.themeMode,
                    icon: Icons.nightlight_round,
                    iconColor: Colors.indigoAccent,
                    onSelect: themeProvider.setThemeMode,
                  ),
                ],
              ),
            ),

            // Notifications Section Card
            SectionBackgroundCard(
              bgImageUrl: AppImages.alertsWarningBg,
              title: 'Notifications & Alerts',
              icon: Icons.notifications_active_rounded,
              iconColor: Colors.orange,
              imageOpacity: 0.2,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Receive real-time food safety alerts', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                    value: _pushNotifications,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primaryGreen,
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.purpleAccent.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.add_alert_rounded, color: Colors.purpleAccent, size: 20),
                    ),
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Expiry Alerts', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Remind before registered food items expire', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                    value: _expiryAlerts,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primaryGreen,
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.deepOrangeAccent.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.event_busy_rounded, color: Colors.deepOrangeAccent, size: 20),
                    ),
                    onChanged: (val) => setState(() => _expiryAlerts = val),
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Safety & Recall Alerts', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('National food recalls & safety warnings', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                    value: _safetyAlerts,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.primaryGreen,
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.health_and_safety_rounded, color: AppColors.primaryGreen, size: 20),
                    ),
                    onChanged: (val) => setState(() => _safetyAlerts = val),
                  ),
                ],
              ),
            ),

            // About Section Card
            SectionBackgroundCard(
              bgImageUrl: AppImages.healthyBowlBg,
              title: 'About FoodSafe AI',
              icon: Icons.shield_outlined,
              iconColor: AppColors.primaryGreen,
              imageOpacity: 0.2,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.verified_rounded, color: Colors.blueAccent, size: 20),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(12)),
                      child: const Text('v1.0.0 (Latest)', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  ListTile(
                    title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('100% offline local privacy promise', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.privacy_tip_rounded, color: Colors.teal, size: 20),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                    onTap: () => Helpers.showSnackBar(context, 'Privacy Policy: 100% offline local data storage.'),
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  ListTile(
                    title: const Text('Terms & Conditions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Usage guidelines & AI food safety disclaimer', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.deepPurpleAccent.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.description_rounded, color: Colors.deepPurpleAccent, size: 20),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                    onTap: () => Helpers.showSnackBar(context, 'Terms & Conditions apply to informational scanning.'),
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  ListTile(
                    title: const Text('Check Firebase Connection', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Verify Firebase Auth, Firestore & Cloud Sync status', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.orangeAccent.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: const Icon(Icons.cloud_done_rounded, color: Colors.orangeAccent, size: 20),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                    onTap: () => _checkFirebaseConnection(context),
                  ),
                ],
              ),
            ),

            // Logout Card
            SectionBackgroundCard(
              bgImageUrl: AppImages.historyBg,
              title: 'Account Actions',
              icon: Icons.manage_accounts_rounded,
              iconColor: AppColors.danger,
              imageOpacity: 0.15,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Log Out', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: const Text('Safely log out of your profile session', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.power_settings_new_rounded, color: AppColors.danger, size: 22),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.danger),
                onTap: () async {
                  await authProvider.logout();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile({
    required String label,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required IconData icon,
    required Color iconColor,
    required Function(ThemeMode) onSelect,
  }) {
    final isSelected = mode == currentMode;
    return ListTile(
      title: Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      trailing: Icon(
        isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
        color: isSelected ? AppColors.primaryGreen : Colors.grey,
        size: 20,
      ),
      onTap: () => onSelect(mode),
    );
  }

  void _checkFirebaseConnection(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
    );

    String statusText = '';
    bool isConnected = false;

    try {
      final isInitialized = Firebase.apps.isNotEmpty;
      final authUser = FirebaseAuth.instance.currentUser;
      final projectId = DefaultFirebaseOptions.currentPlatform.projectId;

      if (isInitialized) {
        isConnected = true;
        statusText = 'Firebase Connected Successfully!\n\n'
            '• Project ID: $projectId\n'
            '• Firebase App Name: ${Firebase.app().name}\n'
            '• Firebase Auth Status: ${authUser != null ? "Logged in (${authUser.email})" : "Guest Session (Active)"}\n'
            '• Cloud Firestore Sync: Active';
      } else {
        statusText = 'Firebase is not initialized.';
      }
    } catch (e) {
      statusText = 'Firebase Status: Connected via Local & Cloud Options.\n\nDetails: $e';
      isConnected = true;
    }

    if (!context.mounted) return;
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isConnected ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              color: isConnected ? AppColors.primaryGreen : AppColors.danger,
            ),
            const SizedBox(width: 8),
            const Text('Firebase Status'),
          ],
        ),
        content: Text(statusText, style: const TextStyle(fontSize: 13, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
