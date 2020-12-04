import "package:flutter/material.dart";
import "Central.dart";
import "Home.dart";
import "Shared/SharedPreference.dart";
import "dart:io";

class Splash extends StatelessWidget {
  static final String id = "Splash";
  Widget build(BuildContext context) {
    reDirector(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: MyApp(),
    );
  }

  reDirector(BuildContext context) async {
    SharedPreference.initializer().stringGetter("isLogin").then((result) {
      if (result == null) {
        Future.delayed(Duration(seconds: 4), () {
          Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
        });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushNamedAndRemoveUntil(
              context, Central.id, (route) => false);
        });
      }
    });
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/preloder.gif",
          width: MediaQuery.of(context).size.width),
    );
  }
}
