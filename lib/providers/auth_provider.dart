import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  bool get isLoggedIn => _accessToken != null;

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access');
    _refreshToken = prefs.getString('refresh');
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      final tokens = await ApiService.login(username, password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', tokens['access']);
      await prefs.setString('refresh', tokens['refresh']);

      _accessToken = tokens['access'];
      _refreshToken = tokens['refresh'];

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }
}
