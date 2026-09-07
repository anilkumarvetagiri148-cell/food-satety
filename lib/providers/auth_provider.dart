import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoggedIn => LocalStorageService.isLoggedIn();
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadUser();
  }

  void _loadUser() {
    _user = LocalStorageService.getUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await AuthService.login(email: email, password: password);
      if (success) {
        _user = LocalStorageService.getUser();
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await AuthService.signUp(name: name, email: email, password: password);
      if (success) {
        _user = LocalStorageService.getUser();
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> updateUser(UserModel updatedUser) async {
    await LocalStorageService.saveUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }
}
