import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/alert_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/alert_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/empty_state.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  int _currentIndex = 3; // Alerts tab

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context);
    final alerts = alertProvider.alerts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Safety Alerts'),
        actions: [
          if (alertProvider.unreadCount > 0)
            TextButton(
              onPressed: () => alertProvider.markAllAsRead(),
              child: const Text('Mark all read', style: TextStyle(color: AppColors.primaryGreen)),
            ),
        ],
      ),
      body: SafeArea(
        child: alerts.isEmpty
            ? const EmptyState(
                title: 'No Alerts',
                subtitle: 'You are completely up to date on food safety and expiry alerts.',
                icon: Icons.notifications_none,
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return AlertCard(
                    alert: alert,
                    onTap: () {
                      alertProvider.markAsRead(alert.id);
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) Navigator.pushReplacementNamed(context, AppRoutes.home);
          if (index == 1) Navigator.pushNamed(context, AppRoutes.scan);
          if (index == 2) Navigator.pushReplacementNamed(context, AppRoutes.history);
          if (index == 4) Navigator.pushReplacementNamed(context, AppRoutes.profile);
        },
      ),
    );
  }
}
