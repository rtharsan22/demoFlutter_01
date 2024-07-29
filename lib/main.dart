import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginui/presentation/view/login_screen.dart';
import 'package:loginui/presentation/widgets/authWrapper.dart';
import 'package:loginui/constants.dart';
import 'package:loginui/presentation/view/home_sreen.dart';
import 'package:loginui/presentation/view/order_screen.dart';
import 'package:loginui/presentation/view/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFi
      );
  runApp(const InitialScreen());
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/signin': (context) => const SignInScreen(),
        '/home': (context) => const HomeScreen(),
        '/order': (context) => const OrderScreen()
      },
    );
  }
}
