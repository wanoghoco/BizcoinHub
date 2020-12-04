import "package:flutter/material.dart";
import "../Widget/TextFieldContainer.dart";
import "../Central.dart";
import "../Server/Sever.dart";
import 'package:data_connection_checker/data_connection_checker.dart';
import "../Widget/ProgressBar.dart";
import "../Shared/SharedPreference.dart";
import "dart:convert" as convert;

class Password extends StatelessWidget {
  static var password = TextEditingController();
  static var npassword = TextEditingController();
  static var cpassword = TextEditingController();
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
                Text("Change Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                SizedBox(height: 5),
                TextFieldData(
                    field: "Current Password",
                    icon: Icons.lock,
                    controller: password),
                TextFieldData(
                    field: "Password", icon: Icons.lock, controller: npassword),
                TextFieldData(
                    field: "Confirm Passwrord",
                    icon: Icons.lock,
                    controller: cpassword),
                SizedBox(height: 20),
                Container(
                    width: size.width * 0.6,
                    height: 40,
                    child: RaisedButton(
                      onPressed: () {
                        changePassword(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Color(0xff880065),
                      child:
                          Text("Change", style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.66,
    );
  }

  static void showAlert(String message) {
    SnackBar snackbar = SnackBar(
        backgroundColor: Colors.grey[300],
        content: Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xffC51162))));
    MyNav.global.currentState.showSnackBar(snackbar);
  }

  checkConnection() async {
    return await DataConnectionChecker().connectionStatus;
  }

  void changePassword(BuildContext context) async {
    if (npassword.text.length < 4) {
      Password.showAlert("Enter A Valid Password");
      return;
    }

    if (npassword.text != cpassword.text) {
      Password.showAlert("Password Do Not Match");
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          ProgressBar(message: "Please Wait...", color: Color(0xffC51162)),
    );
    DataConnectionStatus connection = await checkConnection();
    if (connection != DataConnectionStatus.connected) {
      Navigator.of(context, rootNavigator: true).pop();
      Password.showAlert("No Internet Connection");
      return;
    }
    changeNow(context, password.text, npassword.text);

    return;
  }

  void changeNow(BuildContext context, String oldpass, String newpass) async {
    SharedPreference.initializer().intGetter("UserID").then((result) {
      print(result);
      if (result != null) {
        Server server = new Server(
            "Https://test.bizcoinhub.com/app/changepassword.ashx?oldpassword=$oldpass&newpassword=$newpass&n=$result");
        server.connect().then((val) {
          try {
            print(val);
            Map ourJson = convert.jsonDecode(val);
            if (ourJson["ReturnCode"] == 0) {
              Navigator.of(context, rootNavigator: true).pop();
              Password.showAlert("Invalid Parameters");
            }
            if (ourJson["ReturnCode"] == 1) {
              Navigator.of(context, rootNavigator: true).pop();
              Password.showAlert("Password Changed");
              password.clear();
              npassword.clear();
              cpassword.clear();
            }
            if (ourJson["ReturnCode"] == 2) {
              Navigator.of(context, rootNavigator: true).pop();
              Password.showAlert("Old Password Incorrect ");
            }
          } catch (ex) {}
        });
      }
    });
  }
}

class TextFieldData extends StatelessWidget {
  final String field;
  final String name;
  final IconData icon;
  final TextEditingController controller;
  TextFieldData({this.field, this.name, this.icon, this.controller});
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(field,
              style: TextStyle(fontSize: 16, color: Color(0xffC51162))),
        )
      ]),
      TextFieldContainer(
          child: TextField(
        controller: controller,
        obscureText: true,
        enabled: true,
        decoration: InputDecoration(
          labelText: (name),
          icon: Icon(icon),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          border: InputBorder.none,
        ),
      ))
    ]);
  }
}
