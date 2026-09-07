import 'package:flutter/material.dart';
import '../app/app_routes.dart';
import '../services/local_storage_service.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Scan Your Food',
      'description': 'Quickly scan food products using your smartphone camera.',
      'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600',
    },
    {
      'title': 'Understand Your Nutrition',
      'description': 'View calories, protein, carbohydrates, fats and other nutritional information.',
      'image': 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=600',
    },
    {
      'title': 'Stay Food Safe',
      'description': 'Receive food safety warnings, expiry alerts and allergen information.',
      'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600',
    },
  ];

  void _onNext() async {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await LocalStorageService.setOnboardingComplete(true);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _onSkip() async {
    await LocalStorageService.setOnboardingComplete(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: _onSkip,
                      child: const Text('Skip', style: TextStyle(color: AppColors.secondaryText, fontSize: 16)),
                    ),
                  ),
                  SizedBox(
                    height: 380,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) => setState(() => _currentIndex = index),
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(
                                page['image']!,
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 220,
                                  color: AppColors.lightGreen,
                                  child: const Icon(Icons.food_bank, size: 80, color: AppColors.primaryGreen),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              page['title']!,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page['description']!,
                              style: const TextStyle(fontSize: 14, color: AppColors.secondaryText, height: 1.4),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index ? AppColors.primaryGreen : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                        onPressed: _onNext,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
