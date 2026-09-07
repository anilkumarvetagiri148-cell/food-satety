import 'package:flutter/material.dart';
import '../models/scan_model.dart';
import '../services/local_storage_service.dart';

class HistoryProvider with ChangeNotifier {
  List<ScanModel> _scans = [];
  String _filter = 'All'; // 'All', 'Safe', 'Warning', 'Unsafe'
  String _searchQuery = '';

  List<ScanModel> get scans {
    var list = _scans;
    if (_filter != 'All') {
      list = list.where((s) => s.food.status.toUpperCase() == _filter.toUpperCase()).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((s) => s.food.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  List<ScanModel> get allScans => _scans;

  HistoryProvider() {
    loadScans();
  }

  void loadScans() {
    _scans = LocalStorageService.getScans();
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> refresh() async {
    loadScans();
  }
}
