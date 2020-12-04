import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import "Widget/Carousel.dart";
import "Referer.dart";
import "Login.dart";
import "dart:io";

class Home extends StatelessWidget {
  static final String id = "Home";
  Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Text("Are You Sure You Want To Exit",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child:
                        Text("No", style: TextStyle(color: Color(0xfffd7e14)))),
                FlatButton(
                    onPressed: () {
                      exit(0);
                    },
                    child:
                        Text("Yes", style: TextStyle(color: Color(0xfffd7e14))))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () {
              _onBackPressed(context);
            },
            child: SafeArea(child: SingleChildScrollView(child: MyApp()))));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
      Container(
          height: size.height * 0.40,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xff1A237E),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                    color: Colors.white38.withOpacity(0.1),
                    spreadRadius: -5,
                    offset: Offset(-5, -5),
                    blurRadius: 30),
                BoxShadow(
                    color: Colors.blue[900].withOpacity(0.2),
                    spreadRadius: 2,
                    offset: Offset(7, 7),
                    blurRadius: 20)
              ]),
          child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                alignment: Alignment.topLeft,
                height: 50,
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.menu, color: Color(0xff1A237E))),
                )),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset("assets/biz.png", width: 250),
            ),
            Text("Take Your",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 5),
            Text("Investment Strategy",
                style: TextStyle(color: Color(0xfffd7e14), fontSize: 18)),
            SizedBox(height: 5),
            Text("To The Next Level",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 7),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Login.id, (route) => false);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color(0xfffd7e14),
                        child: Row(children: <Widget>[
                          Icon(Icons.supervised_user_circle_outlined),
                          Text("LOGIN", style: TextStyle(color: Colors.white)),
                        ])),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Referer.id, (route) => false);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color(0xfffd7e14),
                      child: Row(children: <Widget>[
                        Icon(Icons.person_add_outlined),
                        SizedBox(width: 3),
                        Text("REGISTER", style: TextStyle(color: Colors.white)),
                      ]),
                    ),
                  ),
                ])
          ])),
      SizedBox(height: 15),
      Wrap(children: <Widget>[
        Column(children: <Widget>[
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 0.3)),
              child: Container(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white38.withOpacity(0.1),
                          spreadRadius: -5,
                          offset: Offset(-5, -5),
                          blurRadius: 30),
                      BoxShadow(
                          color: Colors.blue[900].withOpacity(0.2),
                          spreadRadius: 2,
                          offset: Offset(7, 7),
                          blurRadius: 20)
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffAA00FF), Color(0xff4A148C)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset("assets/checklist.svg",
                      width: 30, color: Colors.white))),
          SizedBox(height: 5),
          Text("EFFICIENCY",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
        ]),
        SizedBox(width: 20),
        Column(children: <Widget>[
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xffF44336), width: 0.3)),
              child: Container(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white38.withOpacity(0.1),
                          spreadRadius: -5,
                          offset: Offset(-5, -5),
                          blurRadius: 30),
                      BoxShadow(
                          color: Colors.blue[900].withOpacity(0.2),
                          spreadRadius: 2,
                          offset: Offset(7, 7),
                          blurRadius: 20)
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xffF44336), Color(0xffB71C1C)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset("assets/transparency.svg",
                      width: 30, color: Colors.white))),
          SizedBox(height: 5),
          Text("TRANSPARENT",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
        ]),
        SizedBox(width: 20),
        Column(children: <Widget>[
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xffffc107), width: 0.5)),
              child: Container(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white38.withOpacity(0.1),
                          spreadRadius: -5,
                          offset: Offset(-5, -5),
                          blurRadius: 30),
                      BoxShadow(
                          color: Colors.blue[900].withOpacity(0.2),
                          spreadRadius: 2,
                          offset: Offset(7, 7),
                          blurRadius: 20)
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xfffd7e14), Color(0xffffc107)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset("assets/shield.svg",
                      width: 30, color: Colors.white))),
          SizedBox(height: 5),
          Text("SECURITY",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
        ])
      ]),
      SizedBox(height: 40),
      Text("OUR INVESTMENT PLANS",
          style: TextStyle(fontSize: 18, color: Color(0xffdc3545))),
      SizedBox(height: 20),
      Carousel(),
      SizedBox(height: 20),
    ]));
  }
}
