import 'package:flutter/material.dart';
import 'package:tugas_resep/models/meal.dart';
import 'package:tugas_resep/services/api_service.dart';
import 'package:tugas_resep/views/detail_page.dart';
import 'package:tugas_resep/views/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Meal> meals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    try {
      final mealsData = await ApiService.getMeals();
      print(mealsData);

      setState(() {
        meals = mealsData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      throw Exception(e);
    }
  }

  void _logout() {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    // await prefs.setBool("isLoggedIn", false);
    // await prefs.remove("username");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePageContent(isLoading: isLoading, meals: meals),
      Center(child: Text("Favorite")),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Resepku", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: "Favorite",
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final bool isLoading;
  final List<Meal> meals;
  const HomePageContent({
    super.key,
    required this.isLoading,
    required this.meals,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Resep Chicken",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          isLoading
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(mealId: meal.id),
                            ),
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Image.network(meal.image),
                              SizedBox(height: 8),
                              Text(
                                meal.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
