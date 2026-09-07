import 'dart:math';
import '../models/food_model.dart';
import '../models/nutrition_model.dart';

class FoodScanService {
  static final List<FoodModel> _mockFoods = [
    FoodModel(
      name: 'Fresh Organic Apple',
      status: 'SAFE',
      expiryDate: '10 Sep 2026',
      ingredients: ['100% Organic Fresh Apple'],
      allergens: [],
      nutrition: NutritionModel(
        calories: 95,
        protein: 0.5,
        carbohydrates: 25.0,
        fat: 0.3,
        fiber: 4.4,
        sugar: 19.0,
        sodium: 2.0,
      ),
      safetyRecommendation: 'Completely safe for daily consumption. Rich in dietary fiber and Vitamin C.',
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500',
    ),
    FoodModel(
      name: 'Whole Milk (1L)',
      status: 'WARNING',
      expiryDate: '08 Sep 2026',
      ingredients: ['Pasteurized Grade A Cow Milk', 'Vitamin D3'],
      allergens: ['Dairy / Lactose'],
      nutrition: NutritionModel(
        calories: 149,
        protein: 8.0,
        carbohydrates: 12.0,
        fat: 8.0,
        fiber: 0.0,
        sugar: 12.0,
        sodium: 105.0,
      ),
      safetyRecommendation: 'Check expiry date carefully. Consume within 24 hours of opening if refrigerated.',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500',
    ),
    FoodModel(
      name: 'Artisan Whole Wheat Bread',
      status: 'SAFE',
      expiryDate: '15 Sep 2026',
      ingredients: ['Whole Wheat Flour', 'Water', 'Yeast', 'Sea Salt', 'Honey'],
      allergens: ['Wheat / Gluten'],
      nutrition: NutritionModel(
        calories: 80,
        protein: 4.0,
        carbohydrates: 15.0,
        fat: 1.0,
        fiber: 3.0,
        sugar: 2.0,
        sodium: 140.0,
      ),
      safetyRecommendation: 'Healthy whole grain source. Store in a cool, dry place.',
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
    ),
    FoodModel(
      name: 'Crispy Potato Chips',
      status: 'UNSAFE',
      expiryDate: '20 Nov 2026',
      ingredients: ['Potatoes', 'Vegetable Oil', 'Salt', 'Artificial Flavor Enhancers', 'MSG'],
      allergens: ['Soybean (Processed in facility)'],
      nutrition: NutritionModel(
        calories: 160,
        protein: 2.0,
        carbohydrates: 15.0,
        fat: 10.0,
        fiber: 1.2,
        sugar: 0.5,
        sodium: 350.0,
      ),
      safetyRecommendation: 'High sodium and saturated fat content. Consumption should be strictly limited.',
      imageUrl: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500',
    ),
    FoodModel(
      name: 'Classic Cola Soft Drink',
      status: 'UNSAFE',
      expiryDate: '01 Dec 2026',
      ingredients: ['Carbonated Water', 'High Fructose Corn Syrup', 'Caramel Color', 'Phosphoric Acid', 'Caffeine'],
      allergens: [],
      nutrition: NutritionModel(
        calories: 140,
        protein: 0.0,
        carbohydrates: 39.0,
        fat: 0.0,
        fiber: 0.0,
        sugar: 39.0,
        sodium: 45.0,
      ),
      safetyRecommendation: 'Extremely high sugar content. Avoid frequent consumption to protect metabolic health.',
      imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500',
    ),
  ];

  static Future<FoodModel> analyzeFood([String? query]) async {
    await Future.delayed(const Duration(milliseconds: 2000)); // Simulate AI analysis
    if (query != null && query.isNotEmpty) {
      final match = _mockFoods.firstWhere(
        (f) => f.name.toLowerCase().contains(query.toLowerCase()),
        orElse: () => _mockFoods[Random().nextInt(_mockFoods.length)],
      );
      return match;
    }
    return _mockFoods[Random().nextInt(_mockFoods.length)];
  }
}
