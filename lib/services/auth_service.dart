import '../models/user_model.dart';
import 'local_storage_service.dart';

class AuthService {
  static Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200)); // Simulate network delay
    final user = UserModel(
      name: name,
      email: email,
      totalScans: 12,
      safeScans: 8,
      warningScans: 3,
      unsafeScans: 1,
    );
    await LocalStorageService.saveUser(user);
    return true;
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final existingUser = LocalStorageService.getUser();
    if (existingUser != null && existingUser.email.toLowerCase() == email.toLowerCase()) {
      await LocalStorageService.saveUser(existingUser);
      return true;
    } else {
      // Create account automatically or log in with mock session if none exists
      final user = UserModel(
        name: email.split('@').first.capitalize(),
        email: email,
        totalScans: 12,
        safeScans: 8,
        warningScans: 3,
        unsafeScans: 1,
      );
      await LocalStorageService.saveUser(user);
      return true;
    }
  }

  static Future<void> logout() async {
    await LocalStorageService.clearUser();
  }

  static Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
