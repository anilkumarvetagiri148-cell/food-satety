class NutritionModel {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;

  NutritionModel({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'carbohydrates': carbohydrates,
        'fat': fat,
        'fiber': fiber,
        'sugar': sugar,
        'sodium': sodium,
      };

  factory NutritionModel.fromJson(Map<String, dynamic> json) => NutritionModel(
        calories: (json['calories'] ?? 0.0).toDouble(),
        protein: (json['protein'] ?? 0.0).toDouble(),
        carbohydrates: (json['carbohydrates'] ?? 0.0).toDouble(),
        fat: (json['fat'] ?? 0.0).toDouble(),
        fiber: (json['fiber'] ?? 0.0).toDouble(),
        sugar: (json['sugar'] ?? 0.0).toDouble(),
        sodium: (json['sodium'] ?? 0.0).toDouble(),
      );
}
