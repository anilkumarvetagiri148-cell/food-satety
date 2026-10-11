import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyFoodSafetyAiAppKeyForScanning123456',
    appId: '1:109876543210:web:a1b2c3d4e5f67890',
    messagingSenderId: '109876543210',
    projectId: 'food-safety-ai-app',
    authDomain: 'food-safety-ai-app.firebaseapp.com',
    storageBucket: 'food-safety-ai-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyFoodSafetyAiAppKeyForScanning123456',
    appId: '1:109876543210:android:a1b2c3d4e5f67890',
    messagingSenderId: '109876543210',
    projectId: 'food-safety-ai-app',
    storageBucket: 'food-safety-ai-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyFoodSafetyAiAppKeyForScanning123456',
    appId: '1:109876543210:ios:a1b2c3d4e5f67890',
    messagingSenderId: '109876543210',
    projectId: 'food-safety-ai-app',
    storageBucket: 'food-safety-ai-app.appspot.com',
    iosBundleId: 'com.example.foodSafetyNew',
  );
}
