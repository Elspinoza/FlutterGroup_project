import 'dart:convert';

import 'package:furniture_app/models/Categories.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

// Fetch our Categories from API
Future<List<Category>> fetchCategories() async {
  final response = await http.get(Uri.parse('$apiUrl/categories'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    /* List<Category> categories = (json.decode(response.body) as List)
        .map((data) => Category.fromJson(data))
        .toList(); */
    final jsonResponse = json.decode(response.body);
    if (jsonResponse != null && jsonResponse is List) {
      return jsonResponse.map((json) => Category.fromJson(json)).toList();
    }
  }
  throw Exception('Failed to load');
}