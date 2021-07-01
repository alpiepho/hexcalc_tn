import 'package:flutter/material.dart';
import 'package:hexcalc_tn/constants.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
class CalcButton extends StatelessWidget {
  CalcButton({
    required this.color, 
    required this.margin, 
    required this.portrait,
    this.gradient = true,
    this.disabled = false,
    this.cardChild, 
    this.onPress});

  final Color color;
  final EdgeInsets margin;
  final bool portrait;
  final bool gradient;
  final bool disabled;
  final Widget? cardChild;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    var colorTop = color;
    var colorBottom = (gradient ? darken(color, 0.2) : color);
    return InkWell(
        onTap: onPress as void Function()?,
        splashColor: (disabled ? Colors.transparent : Colors.white),
        child: Container(
          child: cardChild,
          margin: margin,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorTop,
                colorBottom,
              ],
            )

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
