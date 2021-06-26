import 'package:flutter/material.dart';

class TeamTiles extends StatelessWidget {
  TeamTiles({required this.color, required this.margin, required this.portrait, this.cardChild, this.onPress, this.onPan});

  final Color color;
  final EdgeInsets margin;
  final bool portrait;
  final Widget? cardChild;
  final Function? onPress;
  final Function? onPan;

  @override
  Widget build(BuildContext context) {
    return Divider();
  }

  // <Widget>[] build2() {
  //   return <Widget>[
  //           Divider(),
  //           Divider(),
  //           Divider(),
  //           Divider(),
  //   ];
  // }
}

