import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/scan_model.dart';
import '../models/alert_model.dart';
import '../utils/app_constants.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memoryCache = {};

  static Future<void> init() async {
    if (_prefs != null) return;
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (_) {
      // Fallback to memory cache if SharedPreferences fails
    }
  }

  // Auth & User Profile
  static Future<void> saveUser(UserModel user) async {
    await init();
    _memoryCache['user_profile'] = jsonEncode(user.toJson());
    _memoryCache[AppConstants.keyIsLoggedIn] = true;
    _memoryCache[AppConstants.keyUserEmail] = user.email;
    _memoryCache[AppConstants.keyUserName] = user.name;
    try {
      await _prefs?.setString('user_profile', jsonEncode(user.toJson()));
      await _prefs?.setBool(AppConstants.keyIsLoggedIn, true);
      await _prefs?.setString(AppConstants.keyUserEmail, user.email);
      await _prefs?.setString(AppConstants.keyUserName, user.name);
    } catch (_) {}
  }

  static UserModel? getUser() {
    try {
      final jsonStr = _prefs?.getString('user_profile') ?? _memoryCache['user_profile'];
      if (jsonStr == null) return null;
      return UserModel.fromJson(jsonDecode(jsonStr));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await init();
    _memoryCache.remove('user_profile');
    _memoryCache[AppConstants.keyIsLoggedIn] = false;
    _memoryCache.remove(AppConstants.keyUserEmail);
    _memoryCache.remove(AppConstants.keyUserName);
    try {
      await _prefs?.remove('user_profile');
      await _prefs?.setBool(AppConstants.keyIsLoggedIn, false);
      await _prefs?.remove(AppConstants.keyUserEmail);
      await _prefs?.remove(AppConstants.keyUserName);
    } catch (_) {}
  }

  static bool isLoggedIn() {
    try {
      return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? _memoryCache[AppConstants.keyIsLoggedIn] ?? false;
    } catch (_) {
      return false;
    }
  }

  // Onboarding
  static Future<void> setOnboardingComplete(bool complete) async {
    await init();
    _memoryCache[AppConstants.keyOnboardingComplete] = complete;
    try {
      await _prefs?.setBool(AppConstants.keyOnboardingComplete, complete);
    } catch (_) {}
  }

  static bool isOnboardingComplete() {
    try {
      return _prefs?.getBool(AppConstants.keyOnboardingComplete) ?? _memoryCache[AppConstants.keyOnboardingComplete] ?? false;
    } catch (_) {
      return false;
    }
  }

  // Theme
  static Future<void> setThemeMode(String mode) async {
    await init();
    _memoryCache[AppConstants.keyThemeMode] = mode;
    try {
      await _prefs?.setString(AppConstants.keyThemeMode, mode);
    } catch (_) {}
  }

  static String getThemeMode() {
    try {
      return _prefs?.getString(AppConstants.keyThemeMode) ?? _memoryCache[AppConstants.keyThemeMode] ?? 'System';
    } catch (_) {
      return 'System';
    }
  }

  // Scans History
  static Future<void> saveScan(ScanModel scan) async {
    await init();
    final scans = getScans();
    scans.insert(0, scan);
    final jsonList = scans.map((s) => s.toJson()).toList();
    _memoryCache[AppConstants.keySavedScans] = jsonEncode(jsonList);
    try {
      await _prefs?.setString(AppConstants.keySavedScans, jsonEncode(jsonList));
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('scans').doc(scan.id).set({
          ...scan.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  static List<ScanModel> getScans() {
    try {
      final jsonStr = _prefs?.getString(AppConstants.keySavedScans) ?? _memoryCache[AppConstants.keySavedScans];
      if (jsonStr == null) return [];
      final List list = jsonDecode(jsonStr);
      return list.map((e) => ScanModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // Alerts
  static Future<void> saveAlerts(List<AlertModel> alerts) async {
    await init();
    final jsonList = alerts.map((a) => a.toJson()).toList();
    _memoryCache[AppConstants.keyAlertsState] = jsonEncode(jsonList);
    try {
      await _prefs?.setString(AppConstants.keyAlertsState, jsonEncode(jsonList));
    } catch (_) {}
  }

  static List<AlertModel> getAlerts() {
    try {
      final jsonStr = _prefs?.getString(AppConstants.keyAlertsState) ?? _memoryCache[AppConstants.keyAlertsState];
      if (jsonStr == null) {
        return [
          AlertModel(
            id: '1',
            category: 'Expiry Alert',
            title: 'Milk expires tomorrow',
            description: 'Your registered Whole Milk product expires on September 8, 2026.',
            date: 'Sep 7, 2026',
            severity: 'High',
            isRead: false,
          ),
          AlertModel(
            id: '2',
            category: 'Food Safety Alert',
            title: 'Recall on Organic Spinach',
            description: 'Batch #4492 reported potential listeria contamination in regional stores.',
            date: 'Sep 5, 2026',
            severity: 'High',
            isRead: false,
          ),
          AlertModel(
            id: '3',
            category: 'Allergen Alert',
            title: 'Contains Peanuts',
            description: 'Scanned snack product contains undeclared peanut traces in new formulation.',
            date: 'Sep 3, 2026',
            severity: 'Medium',
            isRead: true,
          ),
        ];
      }
      final List list = jsonDecode(jsonStr);
      return list.map((e) => AlertModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
