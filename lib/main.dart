import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "Home.dart";
import "Register.dart";
import "Login.dart";
import "Referer.dart";
import "Central.dart";
import "Splash.dart";
import "PasswordF.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(0xff1A237E)));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        theme: ThemeData(
            fontFamily: ("Brand-Regular"), primaryColor: Color(0xff1A237E)),
        routes: {
          Home.id: (context) => Home(),
          Register.id: (context) => Register(),
          Login.id: (context) => Login(),
          Referer.id: (context) => Referer(),
          Central.id: (context) => Central(),
          Splash.id: (context) => Splash(),
          PasswordF.id: (contextt) => PasswordF(),
        },
        initialRoute: Splash.id);
  }
}
