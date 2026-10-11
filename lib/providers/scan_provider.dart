import 'package:flutter/material.dart';
import '../data/food_database.dart';
import '../models/food_model.dart';
import '../models/scan_model.dart';
import '../services/food_scan_service.dart';
import '../services/local_storage_service.dart';

class ScanProvider with ChangeNotifier {
  bool _isAnalyzing = false;
  FoodModel? _currentFood;
  String? _currentImagePath;

  bool get isAnalyzing => _isAnalyzing;
  FoodModel? get currentFood => _currentFood;
  String? get currentImagePath => _currentImagePath;

  Future<void> analyzeFood([String? query, String? imagePath, FoodModel? food]) async {
    _isAnalyzing = true;
    _currentImagePath = imagePath ?? food?.image;
    notifyListeners();

    try {
      if (food != null) {
        await Future.delayed(const Duration(milliseconds: 1000));
        _currentFood = food;
      } else {
        _currentFood = await FoodScanService.analyzeFood(query, imagePath);
      }
    } catch (_) {
      _currentFood = FoodDatabase.allFoods[0];
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  Future<void> saveCurrentScan() async {
    if (_currentFood == null) return;
    final scan = ScanModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      food: _currentFood!,
      timestamp: DateTime.now(),
      localImagePath: _currentImagePath ?? _currentFood!.image,
    );
    await LocalStorageService.saveScan(scan);
  }

  void clearCurrent() {
    _currentFood = null;
    _currentImagePath = null;
    notifyListeners();
  }
}
