import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';
import '../utils/helpers.dart';

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
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text('Appearance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('System Default'),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (val) => themeProvider.setThemeMode(val!),
                  activeColor: AppColors.primaryGreen,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Light Mode'),
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (val) => themeProvider.setThemeMode(val!),
                  activeColor: AppColors.primaryGreen,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark Mode'),
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (val) => themeProvider.setThemeMode(val!),
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  value: _pushNotifications,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                SwitchListTile(
                  title: const Text('Expiry Alerts'),
                  value: _expiryAlerts,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _expiryAlerts = val),
                ),
                SwitchListTile(
                  title: const Text('Safety & Recall Alerts'),
                  value: _safetyAlerts,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _safetyAlerts = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('About FoodSafe AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('App Version'),
                  trailing: const Text('1.0.0+1', style: TextStyle(color: AppColors.secondaryText)),
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => Helpers.showSnackBar(context, 'Privacy Policy: 100% offline local data storage.'),
                ),
                ListTile(
                  title: const Text('Terms & Conditions'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => Helpers.showSnackBar(context, 'Terms & Conditions apply to informational scanning.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout / Delete Account
          Card(
            child: ListTile(
              title: const Text('Logout', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.logout, color: AppColors.danger),
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
    );
  }
}
