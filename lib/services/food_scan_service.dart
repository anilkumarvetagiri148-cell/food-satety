import '../data/food_database.dart';
import '../models/food_model.dart';

class FoodScanService {
  /// Analyzes food input (from camera capture, gallery selection, or text query)
  /// and identifies the matching food from the local 40-item database.
  static Future<FoodModel> analyzeFood([String? query, String? imagePath]) async {
    // Simulate realistic scan/analysis delay (1-2 seconds)
    await Future.delayed(const Duration(milliseconds: 1200));

    if (query != null && query.trim().isNotEmpty) {
      return FoodDatabase.findByName(query);
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      final pathLower = imagePath.toLowerCase();
      for (final food in FoodDatabase.allFoods) {
        final keyWord = food.name.toLowerCase().split(' ').first;
        if (pathLower.contains(keyWord) || pathLower.contains(food.id)) {
          return food;
        }
      }
    }

    // Default demo fallback
    return FoodDatabase.allFoods[0];
  }

  static List<FoodModel> getAllFoods() => FoodDatabase.allFoods;

  static List<FoodModel> getCategoryFoods(String category) =>
      FoodDatabase.getByCategory(category);

  static List<FoodModel> searchFoods(String query) =>
      FoodDatabase.search(query);
}
