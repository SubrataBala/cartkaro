import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const CartkaroApp());
}

class CartkaroApp extends StatelessWidget {
  const CartkaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartkaro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}

makdi;
