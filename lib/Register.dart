import "package:flutter/material.dart";
import "Widget/TextFieldContainer.dart";
import 'package:data_connection_checker/data_connection_checker.dart';
import 'Server/Sever.dart';
import "dart:math";
import "Widget/ProgressBar.dart";
import 'dart:convert' as convert;
import "Login.dart";
import "dart:async";
import "Home.dart";

class Register extends StatelessWidget {
  final String refererUserName;

  Register({this.refererUserName});
  static final String id = "Register";
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
            child: SafeArea(
                child: SingleChildScrollView(
                    child: MyApp(
              refererUserName: refererUserName,
            )))));
  }
}

class MyApp extends StatelessWidget {
  final String refererUserName;
  MyApp({this.refererUserName});
  static var userName = TextEditingController();
  static var fullName = TextEditingController();
  static var emailAddress = TextEditingController();
  static var phone = TextEditingController();
  static var location = TextEditingController();
  static var password = TextEditingController();
  static var cPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String display = refererUserName;
    if (refererUserName == null || refererUserName.isEmpty) {
      display = "Admin2";
    }
    Size size = MediaQuery.of(context).size;
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
      Container(
          height: size.height * 0.25,
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
          child: Column(children: <Widget>[
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset("assets/biz.png", width: 250),
            ),
            SizedBox(height: size.height * 0.03),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              SizedBox(width: 15),
              Text("REGISTER",
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
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(children: <Widget>[
                SizedBox(height: 40),
                TextFieldContainer(
                    child: TextField(
                        controller: userName,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: ("User Name"),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 15),
                TextFieldContainer(
                    child: TextField(
                        controller: fullName,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: ("Full Name"),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 15),
                TextFieldContainer(
                    child: TextField(
                        controller: emailAddress,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: ("Email Address"),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 15),
                TextFieldContainer(
                    child: TextField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: ("Phone"),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 15),
                TextFieldContainer(
                    child: TextField(
                        controller: location,
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: ("Location"),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 15),
                TextFieldContainer(
                    child: TextField(
                        controller: password,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: ("Password"),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 15),
                TextFieldContainer(
                    child: TextField(
                        controller: cPassword,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: ("Confirm Password"),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.grey),
                          border: InputBorder.none,
                        ))),
                SizedBox(height: 15),
                TextFieldContainer(
                    child: TextField(
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: (display),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Colors.black),
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
                    child: Text("Register",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                SizedBox(height: 15),
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
    if (userName.text.length < 2) {
      Register.showAlert("Invalid User Name");

      return;
    }
    if (fullName.text.length < 5) {
      Register.showAlert("Enter A Valid Full Name");
      return;
    }
    if (!emailAddress.text.contains("@")) {
      Register.showAlert("Invalid Email Address");
      return;
    }
    if (phone.text.length < 10) {
      Register.showAlert("Enter A Valid Phone Number");
      return;
    }
    if (location.text.length < 10) {
      Register.showAlert("Enter A Valid Home Address");
      return;
    }
    if (password.text.length < 4) {
      Register.showAlert("Enter A Valid Password");
      return;
    }
    if (cPassword.text != password.text) {
      Register.showAlert("Password Do Not Match");
      return;
    }
    DataConnectionStatus connection = await checkConnection();
    if (connection != DataConnectionStatus.connected) {
      Register.showAlert("No Internet Connection");
      return;
    }
    severRegister(context, userName.text, fullName.text, emailAddress.text,
        phone.text, location.text, password.text, 101);
    return;
  }

  severRegister(
    BuildContext context,
    String userName,
    String fullName,
    String emailAddress,
    String phone,
    String location,
    String password,
    int ref,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          ProgressBar(message: "Registration In Progress"),
    );
    print("i am called");

    var now = new DateTime.now();
    Random rand = new Random(now.millisecondsSinceEpoch);
    int min = 1000;
    int max = 4000;
    int r = min + rand.nextInt(max - min);

    final String url =
        "https://Test.bizcoinhub.com/app/register.ashx?username=$userName&name=$fullName&email=$emailAddress&phone=$phone&password=$password&ref=$r";

    Server register = new Server(url);

    register.connect().then((result) {
      try {
        Map ourJson = convert.jsonDecode(result);

        if (ourJson["ReturnCode"] == 0) {
          Navigator.of(context, rootNavigator: true).pop();
          Register.showAlert("Invalid Parameters");
          return;
        }
        if (ourJson["ReturnCode"] == 1) {
          Register.showAlert("Registration Successful");
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushNamedAndRemoveUntil(
                context, Login.id, (route) => false);
          });
        }

        if (ourJson["ReturnCode"] == 2) {
          Navigator.of(context, rootNavigator: true).pop();
          Register.showAlert("Email Already In Use By Another User");
          return;
        }
        if (ourJson["ReturnCode"] == 3) {
          Navigator.of(context, rootNavigator: true).pop();
          Register.showAlert("User Name Already In Use By Another User");
          return;
        } else {
          Register.showAlert("An Error Occured");
          Navigator.of(context, rootNavigator: true).pop();
          return;
        }
      } catch (ex) {
        Register.showAlert(ex);
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
}
