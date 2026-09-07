import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../utils/app_colors.dart';

class ScanAnalysisScreen extends StatelessWidget {
  const ScanAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final scanProvider = Provider.of<ScanProvider>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                  strokeWidth: 4,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Analyzing your food...',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Checking ingredients, safety status, allergens and nutrition values with AI...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.secondaryText, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
