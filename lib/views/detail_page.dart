import 'package:flutter/material.dart';
import 'package:tugas_resep/models/favorite_meal.dart';
import 'package:tugas_resep/services/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailPage extends StatefulWidget {
  final String mealId;
  const DetailPage({super.key, required this.mealId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> mealDetail = {};
  bool isLoading = true;

  Box<FavoriteMeal> box = Hive.box<FavoriteMeal>("favorite_meals");

  @override
  void initState() {
    super.initState();
    fetchMealDetail();
  }

  Future<void> fetchMealDetail() async {
    try {
      final mealData = await ApiService.getMealDetail(widget.mealId);

      setState(() {
        mealDetail = mealData;
        isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool checkStatus(String mealId) {
    return box.containsKey(mealId);
  }

  void deleteFavorite(String mealId) {
    setState(() {
      box.delete(mealId);
    });
  }

  void addFavorite(String mealId) {
    setState(() {
      box.put(
        mealId,
        FavoriteMeal(
          id: mealDetail["idMeal"],
          name: mealDetail["strMeal"],
          image: mealDetail["strMealThumb"],
        ),
      );
    });
  }

  void toggleFavorite(String mealId) {
    setState(() {
      if (checkStatus(mealId)) {
        deleteFavorite(mealId);
      } else {
        addFavorite(mealId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Page"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(mealDetail["strMealThumb"]),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealDetail["strMeal"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Chip(
                              label: Text(mealDetail["strCategory"]),
                              avatar: Icon(
                                Icons.category,
                                color: Colors.orange,
                              ),
                              backgroundColor: Colors.orange.withOpacity(0.1),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.orange.withOpacity(0.2),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Chip(
                              label: Text(mealDetail["strCountry"]),
                              avatar: Icon(Icons.flag, color: Colors.orange),
                              backgroundColor: Colors.orange.withOpacity(0.1),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.orange.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              toggleFavorite(mealDetail["idMeal"]);
                            },
                            icon: Icon(Icons.favorite, color: Colors.white),
                            label: Text(
                              checkStatus(mealDetail["idMeal"])
                                  ? "Hapus dari Favorite"
                                  : "Tambah ke Favorite",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: checkStatus(mealDetail["idMeal"])
                                  ? Colors.red
                                  : Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Bahan-bahan:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        ...List.generate(20, (index) {
                          String ingredientKey = "strIngredient${index + 1}";
                          String measureKey = "strMeasure${index + 1}";

                          if (mealDetail[ingredientKey] != null &&
                              mealDetail[ingredientKey].toString().isNotEmpty) {
                            return Text(
                              "• ${mealDetail[measureKey]} ${mealDetail[ingredientKey]}",
                              style: TextStyle(fontSize: 16),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }),
                        SizedBox(height: 15),
                        Text(
                          "Cara memasak:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          mealDetail["strInstructions"],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
