import 'food_model.dart';

class ScanModel {
  final String id;
  final FoodModel food;
  final DateTime timestamp;
  final String? localImagePath;

  ScanModel({
    required this.id,
    required this.food,
    required this.timestamp,
    this.localImagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'food': food.toJson(),
        'timestamp': timestamp.toIso8601String(),
        'localImagePath': localImagePath,
      };

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json['id'] ?? '',
        food: FoodModel.fromJson(json['food'] ?? {}),
        timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
        localImagePath: json['localImagePath'],
      );
}
