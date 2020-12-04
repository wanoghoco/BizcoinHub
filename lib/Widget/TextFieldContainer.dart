import "package:flutter/material.dart";

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  TextFieldContainer({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: child,
    );
  }
}
