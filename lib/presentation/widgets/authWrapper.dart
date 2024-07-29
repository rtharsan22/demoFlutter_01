import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginui/presentation/view/home_sreen.dart';
import 'package:loginui/presentation/view/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        //if user has sign in navigate the home screen
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        //if user has sign out navigate to login screen
        return const LoginScreen();
      },
    );
  }
}
