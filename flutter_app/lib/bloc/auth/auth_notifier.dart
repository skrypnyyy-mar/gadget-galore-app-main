import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../core/config/env.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier._privateConstructor();
  static final AuthNotifier instance = AuthNotifier._privateConstructor();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _token;
  String? get token => _token;

  String? _userName;
  String? get userName => _userName;

  String? _userEmail;
  String? get userEmail => _userEmail;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _isLoggedIn = _token != null && _token!.isNotEmpty;
    if (_isLoggedIn) {
      try {
        final response = await http.get(
          Uri.parse('${AppConfig.baseUrl}/profile'),
          headers: {'Authorization': 'Bearer $_token'},
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _userName = data['name'];
          _userEmail = data['email'];
        }
      } catch (_) {
        // Silently fail
      }
    }
    notifyListeners();
  }

  void updateProfile(String? name, String? email) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      final user = data['user'];
      _userName = user['name'];
      _userEmail = user['email'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      _isLoggedIn = true;
      notifyListeners();
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
      throw Exception(error);
    }
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      final user = data['user'];
      _userName = user['name'];
      _userEmail = user['email'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      _isLoggedIn = true;
      notifyListeners();
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Login failed';
      throw Exception(error);
    }
  }

  Future<void> refreshToken() async {
    if (_token == null) return;
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': _token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
      } else {
        await logout();
      }
    } catch (_) {
      // Handle network error silently
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
    _userName = null;
    _userEmail = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
