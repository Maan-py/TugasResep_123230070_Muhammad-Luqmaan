class Meal {
  final String id;
  final String name;
  final String category;
  final String image;
  final String country;
  final String instructions;
  final List<String> measures;

  Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.country,
    required this.instructions,
    required this.measures,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> listMeasures = [];

    for (int i = 1; i <= 20; i++) {
      String key = "strMeasure$i";

      if (json[key] != null && json[key].toString().trim().isNotEmpty) {
        listMeasures.add(json[key]);
      }
    }

    return Meal(
      id: json["idMeal"],
      name: json["strMeal"],
      category: json["strCategory"],
      image: json["strMealThumb"],
      country: json["strCountry"],
      instructions: json["strInstructions"],
      measures: listMeasures,
    );
  }
}
