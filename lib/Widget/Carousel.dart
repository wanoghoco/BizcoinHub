import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import "InvestmentPlan.dart";

class Carousel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CarouselData();
  }
}

class CarouselData extends State<Carousel> {
  Widget build(BuildContext context) {
    int _currentState = 0;
    Size size = MediaQuery.of(context).size;
    return CarouselSlider(
        options: CarouselOptions(
          height: size.height * 0.60,
          onPageChanged: (index, reason) {
            setState(() {
              _currentState = index;
            });
          },
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 4),
        ),
        items: <Widget>[
          InvestementPlan(
              picture: "assets/f1.svg",
              percent: "50%",
              planName: "YELLOW BUSH",
              amount: "NGN3,000",
              days: "7Days"),
          InvestementPlan(
              picture: "assets/f2.svg",
              percent: "85%",
              planName: "ONYX",
              amount: "NGN5,000",
              days: "10Days"),
          InvestementPlan(
              picture: "assets/f2.svg",
              percent: "100%",
              planName: "LAVENDER",
              amount: "NGN10,000",
              days: "14Days"),
          InvestementPlan(
              picture: "assets/f3.svg",
              percent: "120%",
              planName: "LILLY",
              amount: "NGN20,000",
              days: "21Days"),
          InvestementPlan(
              picture: "assets/f4.svg",
              percent: "150%",
              planName: "HERBISCUSS",
              amount: "NGN50,000",
              days: "30Days"),
        ]);
  }
}
