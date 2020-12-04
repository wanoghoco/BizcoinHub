import "package:flutter/material.dart";
import "Widget/TextFieldContainer.dart";
import 'package:data_connection_checker/data_connection_checker.dart';
import 'Server/Sever.dart';
import "Widget/ProgressBar.dart";
import 'dart:convert' as convert;
import "dart:async";
import "Home.dart";
import "Register.dart";

class Referer extends StatelessWidget {
  static final String id = "Referer";
  static GlobalKey<ScaffoldState> global = new GlobalKey<ScaffoldState>();
  Future<bool> _onBackPressed(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
    return true;
  }

  static void showAlert(String message) {
    SnackBar snackbar = SnackBar(
        backgroundColor: Colors.grey[300],
        content: Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xfffd7e14))));
    global.currentState.showSnackBar(snackbar);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: global,
        body: WillPopScope(
            onWillPop: () {
              _onBackPressed(context);
            },
            child: SafeArea(child: SingleChildScrollView(child: MyApp()))));
  }
}

class MyApp extends StatelessWidget {
  static var id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
      Container(
          height: size.height * 0.35,
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xff1A237E), boxShadow: [
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset("assets/biz.png", width: 250),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 15),
                      Text("REFERER ID",
                          style: TextStyle(
                              color: Color(0xfffd7e14),
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ]),
                SizedBox(height: 7),
              ])),
      Container(
          decoration: BoxDecoration(color: Color(0xff1A237E)),
          child: Container(
              height: size.height * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFieldContainer(
                        child: TextField(
                            controller: id,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              icon: Icon(Icons.link_off_outlined),
                              hintText: ("Past Referer ID Or Number Here..."),
                              hintStyle:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                              border: InputBorder.none,
                            ))),
                    SizedBox(height: 15),
                    SizedBox(height: 20),
                    Container(
                      width: size.width * 0.6,
                      child: RaisedButton(
                        color: Color(0xfffd7e14),
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(25))),
                        onPressed: () {
                          inputCheck(context);
                        },
                        child: Text("Validate ID",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Or Continue To",
                        style:
                            TextStyle(color: Color(0xfffd7e14), fontSize: 18)),
                    SizedBox(height: 15),
                    Container(
                      width: size.width * 0.4,
                      child: RaisedButton(
                        color: Color(0xfffd7e14),
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(25))),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Register.id, (route) => false);
                        },
                        child: Text("Register",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ])))
    ]));
  }

  checkConnection() async {
    // Simple check to see if we have internet

    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // var listener = DataConnectionChecker().onStatusChange.listen((status) {
    //   switch (status) {
    //     case DataConnectionStatus.connected:
    //       print('Data connection is available.');
    //       break;
    //     case DataConnectionStatus.disconnected:
    //       print('You are disconnected from the internet.');
    //       break;
    //   }
    // });

    return await DataConnectionChecker().connectionStatus;
  }

  void inputCheck(BuildContext context) async {
    if (id.text.length < 4) {
      Referer.showAlert("Invalid Referer ID");
      return;
    }

    DataConnectionStatus connection = await checkConnection();
    if (connection != DataConnectionStatus.connected) {
      Referer.showAlert("No Internet Connection");
      return;
    }
    severLogin(context, id.text);
    return;
  }

  severLogin(BuildContext context, String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          ProgressBar(message: "Validation In Progress"),
    );
    print("i am called");

    final String url = "https://test.bizcoinhub.com/app/getusername.ashx?n=$id";

    Server login = new Server(url);
    login.connect().then((result) {
      try {
        Map ourJson = convert.jsonDecode(result);

        if (ourJson["ReturnCode"] == 0) {
          Navigator.of(context, rootNavigator: true).pop();
          Referer.showAlert("Incorrect Link... User Not Found");
          return;
        }
        if (ourJson["ReturnCode"] == 1) {
          Referer.showAlert("Validation Successful");
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context, rootNavigator: true).pop();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Register(
                          refererUserName: ourJson["Username"],
                        )));
          });

          return;
        }
        if (ourJson["ReturnCode"] == 3) {
          Navigator.of(context, rootNavigator: true).pop();
          Referer.showAlert("Invalid Parameters");
          return;
        } else {
          Referer.showAlert("An Error Occured");
          Navigator.of(context, rootNavigator: true).pop();
          return;
        }
      } catch (ex) {
        Referer.showAlert(ex);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
}
