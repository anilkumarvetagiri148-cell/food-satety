import 'package:flutter/material.dart';
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

  Future<void> analyzeFood([String? query, String? imagePath]) async {
    _isAnalyzing = true;
    _currentImagePath = imagePath;
    notifyListeners();

    try {
      _currentFood = await FoodScanService.analyzeFood(query);
    } catch (_) {
      _currentFood = null;
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
      localImagePath: _currentImagePath,
    );
    await LocalStorageService.saveScan(scan);
  }

  void clearCurrent() {
    _currentFood = null;
    _currentImagePath = null;
    notifyListeners();
  }
}
