import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../mock/products_data.dart'; // fallback
import '../../core/config/env.dart';
import '../../bloc/auth/auth_notifier.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  String get baseUrl => AppConfig.baseUrl;

  Map<String, String> _headers() {
    final token = AuthNotifier.instance.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> getAuthenticated(String endpoint) async {
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
    );
  }

  Future<http.Response> postAuthenticated(String endpoint, Map<String, dynamic> body) async {
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
      body: json.encode(body),
    );
  }

  Future<http.Response> putAuthenticated(String endpoint, Map<String, dynamic> body) async {
    return http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(),
      body: json.encode(body),
    );
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      // Fallback to mock data if backend is not running
      await Future.delayed(const Duration(seconds: 1));
    }
    return mockProducts;
  }
}
