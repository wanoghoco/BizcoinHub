import "package:flutter/material.dart";
import "../Widget/TextFieldContainer.dart";
import "../Central.dart";
import "../Server/Sever.dart";
import 'package:data_connection_checker/data_connection_checker.dart';
import "../Widget/ProgressBar.dart";
import "../Shared/SharedPreference.dart";
import "dart:convert" as convert;
import "../Server/MyCon.dart";

class Transfer extends StatelessWidget {
  static var userName = TextEditingController();
  static var ammount = TextEditingController();
  static var itemList = ValueNotifier(List<MyCon>());
  Widget build(BuildContext context) {
    mainhistory();
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
                Text("Transfer Coins",
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
                    "Note! Username is case sensitive!",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                TextFieldData(
                    field: "User Name",
                    icondata: Icon(Icons.person),
                    controller: userName),
                TextFieldData(
                    field: "Amount",
                    icondata: Icon(Icons.call_to_action),
                    type: TextInputType.number,
                    controller: ammount),
                SizedBox(height: 20),
                Container(
                    width: size.width * 0.6,
                    height: 40,
                    child: RaisedButton(
                      onPressed: () {
                        check(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Color(0xff880065),
                      child:
                          Text("SEND", style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(height: 15),
                Text("Transfer History",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                SizedBox(height: 15),
                ValueListenableBuilder(
                  valueListenable: itemList,
                  builder: (context, listitem, child) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 8, bottom: 10),
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(children: <Widget>[
                            Expanded(
                                child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Text("Date: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(listitem[index].date ?? ""),
                                      ]),
                                      Row(children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(right: 1),
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            )),
                                        Text(
                                          "Successful",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ])
                                    ]),
                                SizedBox(height: 5),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Column(children: <Widget>[
                                        Text("TranID",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            listitem[index].tranID.toString() ??
                                                ""),
                                      ]),
                                      Column(children: <Widget>[
                                        Text("Ammount",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(listitem[index].amount ?? ""),
                                      ]),
                                      Column(children: <Widget>[
                                        Text("Sender",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(listitem[index].sender ?? ""),
                                      ]),
                                    ]),
                                SizedBox(height: 5),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Text("Reciever: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(listitem[index].receiver ?? ""),
                                      ]),
                                    ]),
                              ],
                            ))
                          ]),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: listitem.length,
                      controller: ScrollController(keepScrollOffset: false),
                    );
                  },
                )
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

  void history() {
    SharedPreference.initializer().intGetter("UserID").then((uid) {
      Server server =
          new Server("https://test.bizcoinhub.com/app/gettran.ashx?n=$uid");
      server.connect().then((result) {
        if (result.length < 5) {
          SharedPreference.initializer().stringSetter("TranState", result);
          return;
        }
        fetchdata(result).then((listresult) {
          itemList.value = listresult;
          SharedPreference.initializer().stringSetter("TranState", result);
        });
      });
    });
  }

  void mainhistory() {
    SharedPreference.initializer().stringGetter("TransState").then((result) {
      if (result == null) {
        history();
        return;
      }
      if (result.length < 5) {
        return;
      } else {
        fetchdata(result).then((localhistory) {
          itemList.value = localhistory;
          history();
        });
      }
    });
  }

  void check(BuildContext context) async {
    if (userName.text.length < 2) {
      Transfer.showAlert("Enter A Valid Username");
      return;
    }
    if (ammount.text.length < 1) {
      Transfer.showAlert("Enter Ammount");
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressBar(
          message: "Transaction In Progress", color: Color(0xffC51162)),
    );
    DataConnectionStatus connection = await checkConnection();
    if (connection != DataConnectionStatus.connected) {
      Navigator.of(context, rootNavigator: true).pop();
      Transfer.showAlert("No Internet Connection");
      return;
    }
    transfer(context, userName.text, ammount.text);
  }

  void transfer(BuildContext context, String username, String ammount) {
    SharedPreference.initializer().intGetter("UserID").then((result) {
      if (result != null) {
        print(result);
        Server server = new Server(
            "Https://test.bizcoinhub.com/app/sendcoin.ashx?n=$result&username=$username&amount=$ammount");
        server.connect().then((val) {
          try {
            print(val);
            Map ourJson = convert.jsonDecode(val);
            if (ourJson["ReturnCode"] == 0) {
              Navigator.of(context, rootNavigator: true).pop();
              Transfer.showAlert("Invalid Parameters");
            }
            if (ourJson["ReturnCode"] == 1) {
              Navigator.of(context, rootNavigator: true).pop();
              Transfer.showAlert("Coin Sent");
              Transfer.ammount.clear();
              history();
              MyNav.impReloader();
              userName.clear();
            }
            if (ourJson["ReturnCode"] == 2) {
              Navigator.of(context, rootNavigator: true).pop();
              Transfer.showAlert("Account Not Found.. Check Username");
            }
            if (ourJson["ReturnCode"] == 3) {
              Navigator.of(context, rootNavigator: true).pop();
              Transfer.showAlert("Insufficient Fund");
            }
            if (ourJson["ReturnCode"] == 4) {
              Navigator.of(context, rootNavigator: true).pop();
              Transfer.showAlert("Incorrect Amount Entered");
            }
          } catch (ex) {}
        });
      }
    });
  }

  static void showAlert(String message) {
    SnackBar snackbar = SnackBar(
        backgroundColor: Colors.grey[300],
        content: Text(message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Color(0xffC51162))));
    MyNav.global.currentState.showSnackBar(snackbar);
  }
}

class TextFieldData extends StatelessWidget {
  final String field;
  final Icon icondata;
  final TextInputType type;
  final TextEditingController controller;
  TextFieldData({this.field, this.icondata, this.type, this.controller});
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
          icon: icondata,
          border: InputBorder.none,
        ),
      ))
    ]);
  }
}
