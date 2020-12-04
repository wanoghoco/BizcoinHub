import "package:flutter/material.dart";
import "Widget/TextFieldContainer.dart";
import 'package:data_connection_checker/data_connection_checker.dart';
import 'Server/Sever.dart';
import "Widget/ProgressBar.dart";
import 'dart:convert' as convert;
import "dart:async";
import "Register.dart";
import "Login.dart";
import "Home.dart";

class PasswordF extends StatelessWidget {
  static final String id = "PasswordF";
  static GlobalKey<ScaffoldState> global = new GlobalKey<ScaffoldState>();
  Future<bool> _onBackPressed(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(context, Login.id, (route) => false);
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
  static var userName = TextEditingController();

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
                      Text("FORGOT PASSWORD ?",
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
                            controller: userName,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: ("User Name"),
                              hintStyle:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                              border: InputBorder.none,
                            ))),
                    SizedBox(height: 20),
                    Container(
                      width: size.width * 0.7,
                      child: RaisedButton(
                        color: Color(0xfffd7e14),
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(25))),
                        onPressed: () {
                          inputCheck(context);
                        },
                        child: Text("Retrieve",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't Have An Account ? ",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xfffd7e14))),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Register.id, (route) => false);
                                },
                                child: Text("Register",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xfffd7e14))),
                              ),
                            ])),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Already Have An Account ? ",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xfffd7e14))),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Login.id, (route) => false);
                                },
                                child: Text("Login",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xfffd7e14))),
                              ),
                            ]))
                  ]))),
    ]));
  }

  checkConnection() async {
    return await DataConnectionChecker().connectionStatus;
  }

  void inputCheck(BuildContext context) async {
    if (userName.text.length < 2) {
      PasswordF.showAlert("Invalid User Name");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          ProgressBar(message: "Processing.. Please Wait"),
    );
    DataConnectionStatus connection = await checkConnection();
    if (connection != DataConnectionStatus.connected) {
      PasswordF.showAlert("No Internet Connection");
      Navigator.of(context, rootNavigator: true).pop();
      return;
    }
    severLogin(context, userName.text);
    return;
  }

  severLogin(
    BuildContext context,
    String userName,
  ) async {
    final String url =
        "https://test.bizcoinhub.com/app/forgetpassword.ashx?username=$userName";

    Server login = new Server(url);

    login.connect().then((result) {
      try {
        Map ourJson = convert.jsonDecode(result);

        if (ourJson["ReturnCode"] == 0) {
          Navigator.of(context, rootNavigator: true).pop();
          PasswordF.showAlert("User Not Found");
          return;
        }
        if (ourJson["ReturnCode"] == 1) {
          Navigator.of(context, rootNavigator: true).pop();
          PasswordF.showAlert(
              "Password Sent To Email.. Please Check Your Mail");
          MyApp.userName.clear();

          return;
        }
        if (ourJson["ReturnCode"] == 2) {
          Navigator.of(context, rootNavigator: true).pop();
          PasswordF.showAlert("Invalid Parameters");
          return;
        } else {
          PasswordF.showAlert("An Error Occured");
          Navigator.of(context, rootNavigator: true).pop();
          return;
        }
      } catch (ex) {
        PasswordF.showAlert(ex);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
}
