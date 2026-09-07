import 'package:flutter/material.dart';
import '../models/alert_model.dart';
import '../services/local_storage_service.dart';

class AlertProvider with ChangeNotifier {
  List<AlertModel> _alerts = [];

  List<AlertModel> get alerts => _alerts;

  int get unreadCount => _alerts.where((a) => !a.isRead).length;

  AlertProvider() {
    loadAlerts();
  }

  void loadAlerts() {
    _alerts = LocalStorageService.getAlerts();
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    for (var alert in _alerts) {
      if (alert.id == id) {
        alert.isRead = true;
      }
    }
    await LocalStorageService.saveAlerts(_alerts);
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    for (var alert in _alerts) {
      alert.isRead = true;
    }
    await LocalStorageService.saveAlerts(_alerts);
    notifyListeners();
  }
}
