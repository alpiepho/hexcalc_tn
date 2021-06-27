import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  CalcButton({required this.color, required this.margin, required this.portrait, this.cardChild, this.onPress});

  final Color color;
  final EdgeInsets margin;
  final bool portrait;
  final Widget? cardChild;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapUp: onPress as void Function(TapUpDetails)?,
        child: Container(
          child: cardChild,
          margin: margin,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
  }

  //   Widget build(BuildContext context) {
  //   return RotatedBox(
  //     quarterTurns: (this.portrait ? 1 : 0),
  //     child: GestureDetector(
  //       onTapUp: onPress as void Function(TapUpDetails)?,
  //       onPanUpdate: onPan as void Function(DragUpdateDetails)?,
  //       child: Container(
  //         child: cardChild,
  //         margin: margin,
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           color: color,
  //           borderRadius: BorderRadius.circular(20.0),
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
