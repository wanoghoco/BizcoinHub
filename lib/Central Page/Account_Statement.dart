import "package:flutter/material.dart";
import "../Server/Sever.dart";
import "../Server/MyConvert.dart";
import "../Shared/SharedPreference.dart";

class AccountStatement extends StatelessWidget {
  var itemList = ValueNotifier(List<MyConvert>());
  Widget build(BuildContext context) {
    accDisplay();
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
                  Text("Account Statement",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
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
                                          Text("Start Date: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(listitem[index].startDate),
                                        ]),
                                        Row(children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(right: 1),
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: listitem[index]
                                                            .status
                                                            .toString()
                                                            .toUpperCase() ==
                                                        "PENDING"
                                                    ? Colors.red
                                                    : Colors.green,
                                              )),
                                          Text(
                                            listitem[index].status,
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
                                          Text("S.N",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              listitem[index].subID.toString()),
                                        ]),
                                        Column(children: <Widget>[
                                          Text("Type",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(listitem[index].subType),
                                        ]),
                                        Column(children: <Widget>[
                                          Text("Amount",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(listitem[index].ammount),
                                        ]),
                                        Column(children: <Widget>[
                                          Text("Days",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(listitem[index].days.toString()),
                                        ]),
                                      ]),
                                  SizedBox(height: 5),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(children: <Widget>[
                                          Text("End Date: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(listitem[index].endDate),
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
            ));
      },
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.66,
    );
  }

  void accDisplay() {
    SharedPreference.initializer().intGetter("UserID").then((result) {
      SharedPreference.initializer().stringGetter("Acc").then((value) {
        if (value == null) {
          Server accstatement = new Server(
              "https://test.bizcoinhub.com/app/getsub.ashx?n=$result");
          accstatement.connect().then((val) {
            fetchdata(val).then((listresult) {
              itemList.value = listresult;
              SharedPreference.initializer().stringSetter("Acc", val);
            });
          });
        } else {
          fetchdata(value).then((listresult) {
            itemList.value = listresult;
          });
          Server accstatement = new Server(
              "https://test.bizcoinhub.com/app/getsub.ashx?n=$result");
          accstatement.connect().then((val) {
            fetchdata(val).then((listresult) {
              itemList.value = listresult;
              SharedPreference.initializer().stringSetter("Acc", val);
            });
          });
        }
      });
    });
  }
}
