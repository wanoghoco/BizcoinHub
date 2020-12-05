import "package:flutter/material.dart";
import "../Widget/TextFieldContainer.dart";
import 'package:dropdownfield/dropdownfield.dart';
import "../Central.dart";
import 'package:data_connection_checker/data_connection_checker.dart';
import "../Widget/ProgressBar.dart";
import "../Shared/SharedPreference.dart";
import "dart:convert" as convert;
import "../Server/Sever.dart";
import "package:url_encoder/url_encoder.dart";

class Withdraw extends StatelessWidget {
  static var amount = TextEditingController();
  static var pm = TextEditingController();
  static var pa = TextEditingController();
  static void showAlert(String message) {
    SnackBar snackbar = SnackBar(
        backgroundColor: Colors.grey[300],
        content: Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xffC51162))));
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
                Text("Withdraw",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                SizedBox(height: 15),
                Container(
                  width: size.width * 0.85,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xffC5CAE9),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    "Note! A minimum of 10,000 BCH is allowed for withdrawal!",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                TextFieldData(
                    field: "Amount",
                    type: TextInputType.number,
                    controller: amount),
                TextFieldData1(field: "Payment Method", controller: pm),
                TextFieldData2(
                    field: "Payment Address Details", controller: pa),
                SizedBox(height: 20),
                Container(
                    width: size.width * 0.7,
                    height: 40,
                    child: RaisedButton(
                      onPressed: () {
                        withdraw(
                            context, int.parse(amount.text), pm.text, pa.text);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Color(0xff880065),
                      child: Text("SEND REQUEST",
                          style: TextStyle(color: Colors.white)),
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

  checkConnection() async {
    return await DataConnectionChecker().connectionStatus;
  }

  void withdraw(
      BuildContext context, int am, String method, String address) async {
    try {
      if (am.toString().length < 2) {
        showAlert("Invalid Amount");
        return;
      }
      if (method.length < 3) {
        showAlert("Invalid Payment Method");
        return;
      }
      if (address.length < 5) {
        showAlert("Invalid Payment Address");
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
        showAlert("No Internet Connection");
      }
      SharedPreference.initializer().intGetter("UserID").then((uid) {
        print(uid);
        if (uid != null) {
          SharedPreference.initializer().stringGetter("Username").then((un) {
            print(un);
            if (un != null) {
              address =
                  urlEncode(text: address.replaceAll(new RegExp(r"\s+"), ""));

              Server server = new Server(
                  "Https://test.bizcoinhub.com/app/withdraw.ashx?n=$uid&username=$un&amount=$am&details=$address&method=$method");
              server.connect().then((result) {
                Map ourJson = convert.jsonDecode(result);

                if (ourJson["ReturnCode"] == 0) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showAlert("Insufficent Funds");
                  return;
                }
                if (ourJson["ReturnCode"] == 1) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showAlert("Widthdraw Was Successful");
                  MyNav.impReloader();
                  Withdraw.amount.clear();
                  Withdraw.pm.clear();
                  Withdraw.pa.clear();
                  return;
                }
                if (ourJson["ReturnCode"] == 2) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showAlert("Invalid Parameters");
                  return;
                }
              });
            }
          });
        }
      });
    } catch (e) {}
  }
}

class TextFieldData2 extends StatelessWidget {
  final String field;
  final TextEditingController controller;
  TextFieldData2({this.field, this.controller});
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
      Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: MediaQuery.of(context).size.height * 0.20,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
            maxLines: 99,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ))
    ]);
  }
}

class TextFieldData extends StatelessWidget {
  final String field;
  final TextEditingController controller;
  final TextInputType type;
  TextFieldData({this.field, this.type = TextInputType.text, this.controller});
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
        enabled: true,
        keyboardType: type,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ))
    ]);
  }
}

class TextFieldData1 extends StatelessWidget {
  final String field;
  final TextEditingController controller;
  TextFieldData1({
    this.field,
    this.controller,
  });
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
          child: DropDownField(
        enabled: true,
        controller: controller,
        hintText: ("Select Payment Method"),
        items: method,
        itemsVisibleInDropdown: 4,
      ))
    ]);
  }
}

List<String> method = ["Bitcoin", "Litcoin", "Tron", "Etherium"];
