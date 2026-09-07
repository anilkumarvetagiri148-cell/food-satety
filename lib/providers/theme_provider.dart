import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    final modeStr = LocalStorageService.getThemeMode();
    if (modeStr == 'Light') {
      _themeMode = ThemeMode.light;
    } else if (modeStr == 'Dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String modeStr = 'System';
    if (mode == ThemeMode.light) modeStr = 'Light';
    if (mode == ThemeMode.dark) modeStr = 'Dark';
    await LocalStorageService.setThemeMode(modeStr);
    notifyListeners();
  }
}
