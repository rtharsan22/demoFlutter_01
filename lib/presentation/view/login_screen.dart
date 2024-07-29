import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginui/presentation/themes/colors.dart';
import 'package:loginui/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      //checks if the form is valid.
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      //provides the basic structure of the screen
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        // scroll if it overflows
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                //overlays its children.
                children: <Widget>[
                  Image.asset(
                    bgImage,
                    fit: BoxFit.cover,
                    height: height * 0.50,
                    width: width,
                  ),
                  Container(
                    height: height * 0.50,
                    width: width,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white])),
                  ),
                ],
              ),
              const Center(
                child: Text(
                  appName,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  slogn,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                    8.0), //adds space around the TextField.
                child: Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.4),
                          primaryColor.withOpacity(0.0)
                        ],
                      ),
                      border: const Border(
                          left: BorderSide(color: primaryColor, width: 5))),
                  child: const Text("  $loginString ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      prefixIcon: Icon(
                        Icons.email,
                        color: primaryColor,
                      ),
                      labelText: "EMAIL ADDRESS",
                      labelStyle: TextStyle(fontSize: 20)),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Please enter email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(email)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                child: TextFormField(
                  obscureText: true, // hides the input text for security.
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      prefixIcon: Icon(
                        Icons.lock_open,
                        color: primaryColor,
                      ),
                      labelText: "PASSWORD",
                      labelStyle: TextStyle(fontSize: 20)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(forgetText),
                ),
              ),
              Center(
                child: SizedBox(
                  height: height * 0.06,
                  width: width - 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                    onPressed: _login,
                    child: const Text(
                      "Login to account",
                      style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: const Text("Create Account",
                          style:
                              TextStyle(color: primaryColor, fontSize: 17.0)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
