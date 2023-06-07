import 'dart:convert';

import 'package:furniture_app/models/Product.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

// Fetch our Products from API
Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('$apiUrl/products'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    /* List<Category> categories = (json.decode(response.body) as List)
        .map((data) => Category.fromJson(data))
        .toList(); */
    final jsonResponse = json.decode(response.body);
    if (jsonResponse != null && jsonResponse is List) {
      return jsonResponse.map((json) => Product.fromJson(json)).toList();
    }
  }
  throw Exception('Failed to load');
}
