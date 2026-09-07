import 'package:flutter/material.dart';
import 'custom_button.dart';
import '../utils/app_colors.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.danger),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: CustomButton(text: 'Retry', onPressed: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}
