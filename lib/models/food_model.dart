import 'nutrition_model.dart';

class FoodModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final String description;
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final List<String> allergens;
  final List<String> healthBenefits;
  final String safetyStatus;
  final String recommendation;

  const FoodModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.allergens,
    required this.healthBenefits,
    required this.safetyStatus,
    required this.recommendation,
  });

  // Backward compatibility getters for existing UI components
  String get status => safetyStatus;
  String get imageUrl => image;
  String get safetyRecommendation => recommendation;
  String get expiryDate => 'Fresh Quality';
  List<String> get ingredients => healthBenefits;
  NutritionModel get nutrition => NutritionModel(
        calories: calories,
        protein: protein,
        carbohydrates: carbohydrates,
        fat: fat,
        fiber: fiber,
        sugar: sugar,
        sodium: sodium,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'image': image,
        'description': description,
        'calories': calories,
        'protein': protein,
        'carbohydrates': carbohydrates,
        'fat': fat,
        'fiber': fiber,
        'sugar': sugar,
        'sodium': sodium,
        'allergens': allergens,
        'healthBenefits': healthBenefits,
        'safetyStatus': safetyStatus,
        'recommendation': recommendation,
      };

  factory FoodModel.fromMap(Map<String, dynamic> map) => FoodModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        category: map['category'] ?? 'General',
        image: map['image'] ?? map['imageUrl'] ?? '',
        description: map['description'] ?? '',
        calories: (map['calories'] ?? 0.0).toDouble(),
        protein: (map['protein'] ?? 0.0).toDouble(),
        carbohydrates: (map['carbohydrates'] ?? 0.0).toDouble(),
        fat: (map['fat'] ?? 0.0).toDouble(),
        fiber: (map['fiber'] ?? 0.0).toDouble(),
        sugar: (map['sugar'] ?? 0.0).toDouble(),
        sodium: (map['sodium'] ?? 0.0).toDouble(),
        allergens: List<String>.from(map['allergens'] ?? []),
        healthBenefits: List<String>.from(map['healthBenefits'] ?? map['ingredients'] ?? []),
        safetyStatus: map['safetyStatus'] ?? map['status'] ?? 'SAFE',
        recommendation: map['recommendation'] ?? map['safetyRecommendation'] ?? '',
      );

  Map<String, dynamic> toJson() => toMap();
  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel.fromMap(json);
}
