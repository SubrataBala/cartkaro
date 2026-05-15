import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Use a ValueNotifier to allow widgets to listen for auth changes.
  final ValueNotifier<bool> isLoggedInNotifier = ValueNotifier(false);

  // Singleton pattern to ensure only one instance of AuthService exists.
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedInNotifier.value = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> login(String name, String phone, String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userPhone', phone);
    await prefs.setString('firebaseUid', uid);
    isLoggedInNotifier.value = true;
  }

  void setGuestMode() {
    isLoggedInNotifier.value = false;
  }
}