import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

class SubNavigationBar extends StatefulWidget {
  final int defualtSelectedIndex;
  final Function(int) onchange;
  final int currentItemSelected;
  SubNavigationBar(
      {this.defualtSelectedIndex = 0,
      @required this.onchange,
      this.currentItemSelected});
  @override
  State<StatefulWidget> createState() {
    return _SubNavigationBar();
  }
}

class _SubNavigationBar extends State<SubNavigationBar> {
  int isSelectedIndex = 0;
  @override
  initState() {
    super.initState();
    isSelectedIndex = widget.defualtSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: Row(children: <Widget>[
      navItem(icon: ("assets/bar-chart.svg"), index: 0),
      navItem(icon: ("assets/user.svg"), index: 1),
      navItem(icon: ("assets/dollar.svg"), index: 2),
      navItem(icon: ("assets/wallet.svg"), index: 3),
      navItem(icon: ("assets/money-transfer.svg"), index: 4),
      navItem(icon: ("assets/passkey.svg"), index: 5),
    ]));
  }

  Widget navItem({String icon, int index}) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          widget.onchange(index);
          setState(() {
            isSelectedIndex = index;
          });
        },
        child: Container(
            height: 60,
            width: size.width / 6,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 4,
                      color: widget.currentItemSelected == index
                          ? Color(0xff1A237E)
                          : Colors.white)),
            ),
            child: Container(
                height: 10,
                width: 10,
                child: Center(
                    child: SvgPicture.asset(icon,
                        width: 30, color: Color(0xffC51162))))));
  }
}
