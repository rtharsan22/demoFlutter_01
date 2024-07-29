// we use []=> we included multible dataes
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loginui/presentation/themes/colors.dart';
import 'package:loginui/constants.dart';

class DummyLoginScreen extends StatelessWidget {
  const DummyLoginScreen({super.key});

// stl =>stateless widget
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  bgImage,
                  // height: height,
                  // width: width,        fix the picture full
                  // fit: BoxFit.cover,        display
                  fit: BoxFit.cover,
                  height: height * 0.50,
                  width: width,
                ),
                Container(
                  //container look likes a <div> in html
                  height: height * 0.50,
                  width: width,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          // stops: [0.3, 0.9],            // where is start & end the gradent
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.white])),
                  //colour-variable colours-value
                  //TestStyle is case sensitive
                  // color: Colors.orange.withOpacity(0.3),
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
              padding: const EdgeInsets.all(8.0),
              // padding: const EdgeInsets.only(left:8.0,top:20.0),
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
                child: Text("  $loginString ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                    prefixIcon: Icon(
                      Icons.email,
                      color: primaryColor,
                    ),
                    labelText: "EMAIL ADDRESS",
                    labelStyle: TextStyle(fontSize: 20)
                    //  TextStyle(color: primaryColor)
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryColor)),
                    prefixIcon: Icon(
                      Icons.lock_open,
                      color: primaryColor,
                    ),
                    labelText: "PASSWORD",
                    labelStyle: TextStyle(fontSize: 20)
                    //  TextStyle(color: primaryColor)
                    ),
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
                          borderRadius: BorderRadius.all(
                              Radius.circular(15))) // Button color
                      ),
                  onPressed: () {},
                  child: const Text(
                    "Login to account",
                    style: TextStyle(
                      letterSpacing: 0.5,
                      color: Colors.white, // Text color
                      fontSize: 20.0, // Font size
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
                    onPressed: () {},
                    child: const Text("Create Account",
                        style: TextStyle(color: primaryColor, fontSize: 17.0)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
