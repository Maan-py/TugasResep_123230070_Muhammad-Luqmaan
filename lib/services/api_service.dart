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
}
