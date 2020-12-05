import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "../Login.dart";

class InvestementPlan extends StatelessWidget {
  final String picture;
  final String percent;
  final String planName;
  final String amount;
  final String days;
  InvestementPlan(
      {this.picture, this.percent, this.planName, this.amount, this.days});
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.55,
        width: size.width * 0.8,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.only(
            left: size.width * 0.05, right: size.width * 0.05, bottom: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0.7, 0.7)),
        ]),
        child: Column(children: <Widget>[
          Container(
              height: size.height * 0.2,
              child: Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                        top: 0,
                        child: Container(
                            width: size.width * 0.7,
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(100),
                                      bottomRight: Radius.circular(100)),
                                  child: Image.asset("assets/CardTop.jpg"),
                                )))),
                    Positioned(
                        bottom: -(size.height * 0.025),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(picture,
                                width: 30, color: Colors.red)))
                  ])),
          SizedBox(height: 15),
          Text(percent,
              style: TextStyle(
                  fontSize: 70,
                  color: Color(0xffe40015),
                  fontWeight: FontWeight.bold)),
          Text(planName,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Container(
              width: size.width * 0.6,
              child:
                  Wrap(alignment: WrapAlignment.spaceEvenly, children: <Widget>[
                Text("Amt:"),
                Text(amount,
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffe40015),
                        fontWeight: FontWeight.bold)),
                Text(days),
              ])),
          SizedBox(height: 10),
          RaisedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Login.id, (route) => false);
              },
              color: Color(0xff1A237E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Text("JOIN NOW",
                  style: TextStyle(fontSize: 18, color: Colors.white)))
        ]));
  }
}
