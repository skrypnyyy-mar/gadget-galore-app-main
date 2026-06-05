import '../../bloc/cart/cart_item.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/env.dart';

/// Calculates the delivery cost using the backend API.
Future<double> estimateDeliveryCost(List<CartItem> items) async {
  if (items.isEmpty) return 0.0;
  
  try {
    final payload = items.map((i) => {
      'category': i.product.category,
      'quantity': i.quantity,
    }).toList();

    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/delivery/estimate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'items': payload}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['cost'] as num).toDouble();
    }
  } catch (e) {
    // Fallback on error
  }
  return 100.0;
}
