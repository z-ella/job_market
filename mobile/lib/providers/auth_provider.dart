import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role;
  bool _isAuthenticated = false;

  String? get token => _token;
  String? get role => _role;
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _role == 'admin';

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('access_token');
    _role = prefs.getString('user_role');
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  Future<void> login(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setString('user_role', role);
    _token = token;
    _role = role;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_role');
    _token = null;
    _role = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
