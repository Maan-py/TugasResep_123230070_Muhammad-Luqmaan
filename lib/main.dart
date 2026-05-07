import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tugas_resep/models/favorite_meal.dart';
import 'package:tugas_resep/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding();
  await Hive.initFlutter();

  Hive.registerAdapter(FavoriteMealAdapter());
  await Hive.openBox<FavoriteMeal>("favorite_meals");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aplikasi Resep",
      home: LoginPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
