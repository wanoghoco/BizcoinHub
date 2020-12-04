import "package:flutter/material.dart";
import "Widget/NavBar.dart";
import 'Central Page/Account_Statement.dart';
import "package:flutter_svg/svg.dart";
import "Central Page/Profile.dart";
import "Central Page/Invest.dart";
import "Central Page/Withdraw.dart";
import "Central Page/Transfer.dart";
import "Central Page/Password.dart";
import "Widget/ProgressBar.dart";
import "Shared/SharedPreference.dart";
import "Server/Sever.dart";
import 'dart:convert' as convert;
import "dart:io";
import "Home.dart";

class Central extends StatefulWidget {
  static String id = "Central";
  @override
  State<StatefulWidget> createState() {
    return MyNav();
  }
}

class MyNav extends State<Central> {
  static GlobalKey<ScaffoldState> global = new GlobalKey<ScaffoldState>();
  int itemselected = 0;
  var nv = ValueNotifier(0);
  var pg = ValueNotifier(PageController());
  var userName = ValueNotifier("Name");
  var balance = ValueNotifier("Balance");
  var userID = ValueNotifier("UserID");
  var _pages = [
    AccountStatement(),
    Profile(),
    Invest(),
    Withdraw(),
    Transfer(),
    Password()
  ];
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Text("Are You Sure You Want To Exit"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child:
                        Text("No", style: TextStyle(color: Color(0xff1A237E)))),
                FlatButton(
                    onPressed: () {
                      exit(0);
                    },
                    child:
                        Text("Yes", style: TextStyle(color: Color(0xff1A237E))))
              ]);
        });
  }

  Widget build(BuildContext context) {
    topNotifier();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: global,
        backgroundColor: Colors.white,
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: nv,
            builder: (context, n, child) {
              return SubNavigationBar(
                  onchange: (value) {
                    itemselected = value;
                    pg.value.animateToPage(itemselected,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear);
                  },
                  defualtSelectedIndex: 0,
                  currentItemSelected: n);
            }),
        body: WillPopScope(
            onWillPop: () {
              _onBackPressed();
            },
            child: SafeArea(
                child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100))),
                      child: ValueListenableBuilder(
                          valueListenable: pg,
                          builder: (context, n, child) {
                            return PageView(
                              children: _pages,
                              onPageChanged: (index) {
                                nv.value = index;
                              },
                              controller: n,
                            );
                          })),
                  Container(
                      padding: EdgeInsets.only(top: 18),
                      height: size.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff1A237E),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                      ),
                      child: Column(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child:
                                    Image.asset("assets/biz.png", width: 150),
                              ),
                              Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("hi");
                                      return showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                content: Text(
                                                    "Are You Sure You Want To Logout",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text("No",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff1A237E)))),
                                                  FlatButton(
                                                      onPressed: () {
                                                        SharedPreference
                                                                .logout()
                                                            .then((result) {
                                                          if (result == true) {
                                                            Navigator
                                                                .pushNamedAndRemoveUntil(
                                                                    context,
                                                                    Home.id,
                                                                    (route) =>
                                                                        false);
                                                          }
                                                        });
                                                      },
                                                      child: Text("Yes",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff1A237E))))
                                                ]);
                                          });
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Icon(Icons.logout,
                                            color: Colors.red[900], size: 20)),
                                  )),
                            ]),
                        SizedBox(height: size.height * 0.05),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: SvgPicture.asset(
                                              "assets/user.svg",
                                              width: 35,
                                              color: Color(0xffC51162))),
                                    ),
                                    SizedBox(height: 5),
                                    Text("Username",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    SizedBox(height: 3),
                                    ValueListenableBuilder(
                                      valueListenable: userName,
                                      builder: (context, _userName, _child) {
                                        return Text(_userName,
                                            style:
                                                TextStyle(color: Colors.white));
                                      },
                                    )
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset("assets/m2.svg",
                                            width: 35,
                                            color: Color(0xffC51162))),
                                    SizedBox(height: 5),
                                    Text("Balance",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    SizedBox(height: 3),
                                    ValueListenableBuilder(
                                        valueListenable: balance,
                                        builder: (context, _balance, _child) {
                                          return Text(_balance,
                                              style: TextStyle(
                                                  color: Colors.white));
                                        })
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset("assets/m3.svg",
                                            width: 35,
                                            color: Color(0xffC51162))),
                                    SizedBox(height: 5),
                                    Text("Ref ID",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    SizedBox(height: 3),
                                    ValueListenableBuilder(
                                        valueListenable: userID,
                                        builder: (context, _userID, _child) {
                                          return Text(_userID,
                                              style: TextStyle(
                                                  color: Colors.white));
                                        })
                                  ]),
                            ]),
                      ])),

                  // itemselected == 0
                  //     ? AccountStatement()
                  //     : itemselected == 1
                  //         ? Profile()
                  //         : itemselected == 2
                  //             ? Invest()
                  //             : itemselected == 3
                  //                 ? Withdraw()
                  //                 : itemselected == 4
                  //                     ? Transfer()
                  //                     : itemselected == 5
                  //                         ? Password()
                  //                         : Center(
                  //                             child: Text(
                  //                                 "in Hello World.. Am Coding $itemselected",
                  //                                 style:
                  //                                     TextStyle(fontSize: 17)),
                  //  ),
                ]))));
  }

  void topNotifier() async {
    SharedPreference.initializer().stringGetter("Fullname").then((result) {
      if (result == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              ProgressBar(message: "Initializaion In Progress"),
        );
        SharedPreference.initializer().intGetter("UserID").then((idresult) {
          final String url =
              "https://test.bizcoinhub.com/app/dashboard.ashx?n=$idresult";

          Server basicDetails = new Server(url);
          basicDetails.connect().then((result) {
            try {
              Map ourJson = convert.jsonDecode(result);
              if (ourJson["ReturnCode"] == 1) {
                SharedPreference.initializer()
                    .stringGetter("Username")
                    .then((uresult) {
                  if (uresult.length > 10) {
                    userName.value = uresult.substring(0, 8) + "..";
                  } else {
                    userName.value = uresult;
                  }
                  ;
                });
                balance.value = ourJson["Balance"].toString();
                userID.value = idresult.toString();
                SharedPreference.initializer()
                    .stringSetter("Balance", ourJson["Balance"]);
                SharedPreference.initializer()
                    .stringSetter("Fullname", ourJson["Fullname"]);
              }
              Navigator.of(context, rootNavigator: true).pop();
            } catch (ex) {}
          });
        });
      } else {
        SharedPreference.initializer().stringGetter("Username").then((result) {
          if (result.length > 10) {
            userName.value = result.substring(0, 8) + "..";
          } else {
            userName.value = result;
          }
        });

        SharedPreference.initializer().stringGetter("Balance").then((result) {
          balance.value = result.toString();
        });

        SharedPreference.initializer().intGetter("UserID").then((result) {
          userID.value = result.toString();
        });
      }
    });
  }
}
