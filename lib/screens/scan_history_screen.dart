import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/app_routes.dart';
import '../providers/history_provider.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/scan_card.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  int _currentIndex = 2; // History tab
  final List<String> _filters = ['All', 'Safe', 'Warning', 'Unsafe'];
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final scans = historyProvider.scans;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan History')),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filters
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) => historyProvider.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search scan history...',
                      prefixIcon: const Icon(Icons.search, color: AppNames.primaryGreen),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            selectedColor: AppColors.primaryGreen,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedFilter = filter);
                                historyProvider.setFilter(filter);
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

            // Scan Cards List
            Expanded(
              child: scans.isEmpty
                  ? const EmptyState(
                      title: 'No Scan History',
                      subtitle: 'Your scanned food products will appear here.',
                      icon: Icons.history,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: scans.length,
                      itemBuilder: (context, index) {
                        final scan = scans[index];
                        return ScanCard(
                          scan: scan,
                          onTap: () {
                            scanProvider.analyzeFood(scan.food.name, scan.localImagePath);
                            Navigator.pushNamed(context, AppRoutes.scanResult);
                          },
                        );
                      },
                    ),
            ),
          ],
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

class AppNames {
  static const Color primaryGreen = AppColors.primaryGreen;
}
