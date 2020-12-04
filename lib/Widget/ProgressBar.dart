import "package:flutter/material.dart";

class ProgressBar extends StatelessWidget {
  final String message;
  final Color color;
  ProgressBar({this.message, this.color = const Color(0xfffd7e14)});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.grey[300],
          child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(3),
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 12),
              child: Wrap(
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                    SizedBox(width: 15),
                    Text(message,
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ])),
        ));
  }
}
