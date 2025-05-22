import 'package:flutter/material.dart';
import 'package:myapp/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C6BC0), // aesthetic indigo
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F4FF), // soft background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5C6BC0),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black26,
          elevation: 6,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
