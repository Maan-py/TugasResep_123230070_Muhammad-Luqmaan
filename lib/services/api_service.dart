import 'dart:convert';

import 'package:tugas_resep/models/meal.dart';
import "package:http/http.dart" as http;

class ApiService {
  static const String apiUrl =
      "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken";

  static Future<List<Meal>> getMeals() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List meals = data["meals"];

      return meals.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception("Failed to get meals");
    }
  }

  static Future<Map<String, dynamic>> getMealDetail(String id) async {
    String apiDetailUrl =
        "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id";

    final response = await http.get(Uri.parse(apiDetailUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["meals"][0];
    } else {
      throw Exception("Failed to get meal detail");
    }
  }
}
