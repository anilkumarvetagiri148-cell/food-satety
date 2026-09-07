import 'nutrition_model.dart';

class FoodModel {
  final String name;
  final String status; // 'SAFE', 'WARNING', 'UNSAFE'
  final String expiryDate;
  final List<String> ingredients;
  final List<String> allergens;
  final NutritionModel nutrition;
  final String safetyRecommendation;
  final String imageUrl;

  FoodModel({
    required this.name,
    required this.status,
    required this.expiryDate,
    required this.ingredients,
    required this.allergens,
    required this.nutrition,
    required this.safetyRecommendation,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'status': status,
        'expiryDate': expiryDate,
        'ingredients': ingredients,
        'allergens': allergens,
        'nutrition': nutrition.toJson(),
        'safetyRecommendation': safetyRecommendation,
        'imageUrl': imageUrl,
      };

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        name: json['name'] ?? '',
        status: json['status'] ?? 'SAFE',
        expiryDate: json['expiryDate'] ?? '',
        ingredients: List<String>.from(json['ingredients'] ?? []),
        allergens: List<String>.from(json['allergens'] ?? []),
        nutrition: NutritionModel.fromJson(json['nutrition'] ?? {}),
        safetyRecommendation: json['safetyRecommendation'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
      );
}
