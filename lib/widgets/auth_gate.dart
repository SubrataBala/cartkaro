import 'package:cartkaro/screens/home_screen.dart';
import 'package:cartkaro/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isGuest = false;

  void _setGuestStatus(bool isGuest) {
    if (!mounted) return;
    setState(() {
      _isGuest = isGuest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the stream has data, the user is authenticated.
        if (snapshot.hasData) {
          // If they were previously browsing as a guest, reset the flag.
          if (_isGuest) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _setGuestStatus(false));
          }
          return const HomeScreen();
        }

        // If there's no user but they've chosen to browse as a guest.
        if (_isGuest) {
          return HomeScreen(onGuestLogout: () => _setGuestStatus(false));
        }

        // Otherwise, the user is logged out and not a guest. Show the login screen.
        return LoginScreen(onSkip: () => _setGuestStatus(true));
      },
    );
  }
}