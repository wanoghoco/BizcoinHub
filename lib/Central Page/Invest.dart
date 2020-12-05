import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import 'package:data_connection_checker/data_connection_checker.dart';
import "../Widget/ProgressBar.dart";
import "../Central.dart";
import "../Server/Sever.dart";
import "../Shared/SharedPreference.dart";
import "dart:convert" as convert;

class Invest extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _Invest();
  }
}

class _Invest extends State<Invest> {
  int selectedItem = 0;
  static void showAlert(String message) {
    SnackBar snackbar = SnackBar(
        backgroundColor: Colors.grey[300],
        content: Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xfffd7e14))));
    MyNav.global.currentState.showSnackBar(snackbar);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Text("Choose A Package",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        investementPlan(
                            picture: "assets/f1.svg",
                            percent: "50%",
                            planName: "YELLOW BUSH",
                            amount: "NGN3,000",
                            days: "7Days",
                            size: size,
                            index: 1),
                        investementPlan(
                            picture: "assets/f2.svg",
                            percent: "85%",
                            planName: "ONYX",
                            amount: "NGN5,000",
                            days: "10Days",
                            size: size,
                            index: 2),
                      ]),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        investementPlan(
                            picture: "assets/f2.svg",
                            percent: "100%",
                            planName: "LAVENDER",
                            amount: "NGN10,000",
                            days: "14Days",
                            size: size,
                            index: 3),
                        investementPlan(
                            picture: "assets/f3.svg",
                            percent: "120%",
                            planName: "LILLY",
                            amount: "NGN20,000",
                            days: "21Days",
                            size: size,
                            index: 4),
                      ]),
                  SizedBox(height: 15),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        investementPlan(
                            picture: "assets/f4.svg",
                            percent: "150%",
                            planName: "HERBISCUSS",
                            amount: "NGN50,000",
                            days: "30Days",
                            size: size,
                            index: 5),
                      ]),
                  SizedBox(height: 20),
                ],
              ),
            ));
      },
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.66,
    );
  }

  void sendInvest(int number) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressBar(message: "Please Wait..."),
    );

    DataConnectionStatus connection =
        await DataConnectionChecker().connectionStatus;
    if (connection != DataConnectionStatus.connected) {
      _Invest.showAlert("No Internet Connection");
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }

    SharedPreference.initializer().intGetter("UserID").then((uid) {
      Server server = Server(
          "https://test.bizcoinhub.com/app/buysub.ashx?n=$uid&subid=$number");
      print("https://test.bizcoinhub.com/app/buysub.ashx?n=$uid&subid=$number");
      server.connect().then((result) {
        Map nresult = convert.jsonDecode(result);

        if (nresult["ReturnCode"] == 1) {
          _Invest.showAlert("Purchase Was Successful");
          Navigator.of(context, rootNavigator: true).pop();
          MyNav.impReloader();
          return;
        }
        if (nresult["ReturnCode"] == 2) {
          _Invest.showAlert("Can Not Subscirbe More Than One Package");
          Navigator.of(context, rootNavigator: true).pop();
          return;
        }
        if (nresult["ReturnCode"] == 3) {
          _Invest.showAlert("Insuffiencet Funds");
          Navigator.of(context, rootNavigator: true).pop();
          return;
        }
        if (nresult["ReturnCode"] == 4) {
          _Invest.showAlert("Invalid Parameters");
          Navigator.of(context, rootNavigator: true).pop();
          return;
        }
        _Invest.showAlert("An Error Occured");
        Navigator.of(context, rootNavigator: true).pop();
        return;
      });
    });
  }

  void invest(int number) {}
  Widget investementPlan(
      {String picture,
      String percent,
      String planName,
      String amount,
      String days,
      Size size,
      int index}) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedItem = index;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: Text("Continue To $planName"),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text("No",
                                style: TextStyle(color: Color(0xff1A237E)))),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                              sendInvest(index);
                            },
                            child: Text("Yes",
                                style: TextStyle(color: Color(0xff1A237E))))
                      ]);
                });
          });
        },
        child: Container(
            height: size.height * 0.27,
            width: size.width * 0.4,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                color: selectedItem == index ? Colors.grey[300] : Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0.7, 0.7)),
                ]),
            child: Column(children: <Widget>[
              Container(
                  height: size.height * 0.1,
                  child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                            top: 0,
                            child: Container(
                                width: size.width * 0.4,
                                child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(100),
                                          bottomRight: Radius.circular(100)),
                                      child: Image.asset("assets/CardTop.jpg"),
                                    )))),
                        Positioned(
                            bottom: -(size.height * 0.035),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(picture,
                                    width: 30, color: Color(0xffC51162))))
                      ])),
              SizedBox(height: 19),
              Text(percent,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xffC51162),
                      fontWeight: FontWeight.bold)),
              Text(planName,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(amount,
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xffC51162),
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(days),
            ])));
  }
}
