import "package:hive/hive.dart";
part "favorite_meal.g.dart";

@HiveType(typeId: 0)
class FavoriteMeal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  FavoriteMeal({required this.id, required this.name, required this.image});
}
