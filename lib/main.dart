import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Flutter engine ko properly start karne ke liye (kyunki hum await use kar rahe hain)
  WidgetsFlutterBinding.ensureInitialized(); 

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // ── CHECK KAREGA KI KYA USER PEHLE SE LOGIN HAI ──
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(CartkaroApp(isLoggedIn: loggedIn));
}

class CartkaroApp extends StatelessWidget {
  final bool isLoggedIn;
  const CartkaroApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartkaro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      // ── AGAR PEHLE SE LOGIN HAI TOH DIRECT HOME, WARNA LOGIN SCREEN ──
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}