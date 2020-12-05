import "package:flutter/material.dart";
import "../Widget/TextFieldContainer.dart";
import "../Shared/SharedPreference.dart";
import "dart:convert" as convert;
import "../Server/Sever.dart";
import 'package:flutter/services.dart';
import "../Central.dart";

class Profile extends StatelessWidget {
  static var userName = ValueNotifier("userName");
  static var fullName = ValueNotifier("fullName");
  static var emailAddress = ValueNotifier("emailAddress");
  static var phone = ValueNotifier("phone");
  static var upline = ValueNotifier("upline");
  static var myLink = ValueNotifier("myLink");
  static var downline = ValueNotifier("downline");
  static var cnt = TextEditingController();
  Widget build(BuildContext context) {
    fretrieve();
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
                Text("Account Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
                SizedBox(height: 5),
                ValueListenableBuilder(
                    valueListenable: userName,
                    builder: (context, value, child) {
                      return TextFieldData(field: "User Name", name: value);
                    }),
                ValueListenableBuilder(
                    valueListenable: fullName,
                    builder: (context, value, child) {
                      return TextFieldData(field: "Fullname", name: value);
                    }),
                ValueListenableBuilder(
                    valueListenable: emailAddress,
                    builder: (context, value, child) {
                      return TextFieldData(field: "Email Address", name: value);
                    }),
                ValueListenableBuilder(
                    valueListenable: phone,
                    builder: (context, value, child) {
                      return TextFieldData(field: "Phone", name: value);
                    }),
                ValueListenableBuilder(
                    valueListenable: upline,
                    builder: (context, value, child) {
                      return TextFieldData(field: "Upline", name: value);
                    }),
                ValueListenableBuilder(
                    valueListenable: myLink,
                    builder: (context, value, child) {
                      return TextFieldData4(field: "Referer Link", name: value);
                    }),
                ValueListenableBuilder(
                    valueListenable: downline,
                    builder: (context, value, child) {
                      return TextFieldData3(field: "Downline", name: value);
                    }),
                SizedBox(height: 25),
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

  void fretrieve() async {
    SharedPreference.initializer().stringGetter("EmailAddress").then((result) {
      if (result == null) {
        retrieve();
      } else {
        SharedPreference.initializer().stringGetter("Username").then((name) {
          userName.value = name;
          myLink.value = "https://bizcoinhub.com/signup?ref=$name";
        });
        SharedPreference.initializer().stringGetter("Fullname").then((name) {
          fullName.value = name;
        });
        SharedPreference.initializer()
            .stringGetter("EmailAddress")
            .then((name) {
          emailAddress.value = name;
        });
        SharedPreference.initializer().stringGetter("Phone").then((name) {
          phone.value = name;
        });
        SharedPreference.initializer().stringGetter("refName").then((name) {
          upline.value = name;
        });
        SharedPreference.initializer().stringGetter("downline").then((name) {
          downline.value = name;
        });
        retrieve();
      }
    });
  }

  void retrieve() async {
    SharedPreference.initializer().intGetter("UserID").then((result) {
      Server server = new Server(
          "Https://test.bizcoinhub.com/app/getprofile.ashx?n=$result");
      server.connect().then((val) {
        Map ourJson = convert.jsonDecode(val);
        SharedPreference.initializer().stringGetter("Username").then((name) {
          userName.value = name;
        });
        fullName.value = ourJson["Fullname"];
        emailAddress.value = ourJson["Email"];
        phone.value = ourJson["Phone"];
        upline.value = ourJson["refName"];
        myLink.value = "https://bizcoinhub.com/signup?ref=$result";
        SharedPreference.initializer()
            .stringSetter("EmailAddress", ourJson["Email"]);
        SharedPreference.initializer().stringSetter("Phone", ourJson["Phone"]);
        SharedPreference.initializer()
            .stringSetter("refName", ourJson["refName"]);
      });
      SharedPreference.initializer().stringGetter("Username").then((myname) {
        Server mydata = new Server(
            "https://test.bizcoinhub.com/app/getdownline.ashx?username=$myname");
        print(myname);
        print(myname);
        print(myname);
        print(myname);
        mydata.connect().then((data) {
          data = data.replaceAll(RegExp(r'Fullname\"\:'), "");
          data = data.replaceAll(RegExp(r'"'), "");
          data = data.replaceAll(RegExp(r'\['), "");
          data = data.replaceAll(RegExp(r'{'), "");
          data = data.replaceAll(RegExp(r'}'), "");
          data = data.replaceAll(RegExp(r']'), "");
          downline.value = data == "0" ? "" : data;
          SharedPreference.initializer().stringSetter("downline", data);
          print(data);
        });
      });
    });
  }
}

class TextFieldData extends StatelessWidget {
  final String field;
  final String name;
  TextFieldData({this.field, this.name});
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
        enabled: false,
        decoration: InputDecoration(
          labelText: (name),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          disabledBorder: InputBorder.none,
        ),
      ))
    ]);
  }
}

class TextFieldData2 extends StatelessWidget {
  final String field;
  final String name;
  TextFieldData2({this.field, this.name});
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
          height: MediaQuery.of(context).size.height * 0.35,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: (name),
              labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              disabledBorder: InputBorder.none,
            ),
          ))
    ]);
  }
}

class TextFieldData3 extends StatelessWidget {
  final String field;
  final String name;
  static var cnt = TextEditingController();

  TextFieldData3({this.field, this.name}) {
    cnt.text = name;
  }
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
            controller: cnt,
            enabled: false,
            maxLines: 99,
          ))
    ]);
  }
}

class TextFieldData4 extends StatelessWidget {
  final String field;
  final String name;
  TextFieldData4({this.field, this.name});
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
        enabled: true,
        showCursor: true,
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
              onTap: () async {
                print("amen");
                Clipboard.setData(ClipboardData(text: name)).then((result) {
                  Profile.showAlert("Copied");
                  print("amen");
                });
              },
              child: Icon(Icons.copy_outlined)),
          hintText: (name),
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          border: InputBorder.none,
        ),
      ))
    ]);
  }
}
