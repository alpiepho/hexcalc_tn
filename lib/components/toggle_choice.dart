import 'package:flutter/material.dart';
// import 'package:hexcalc_tn/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';


class ToggleChoice extends StatelessWidget {
  ToggleChoice({
    required this.index, 
    required this.label,
    required this.onToggle});

  final int index;
  final String label;
  final Function(int) onToggle;

  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: new Text(
            label,
            style: TextStyle(
              fontSize: 16,
              //fontWeight: FontWeight.w700,
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: new SizedBox(width: 70),
          flex: 1,
        ),
        Expanded(
          child: ToggleSwitch(
            minWidth: 30.0,
            minHeight: 30.0,
            cornerRadius: 20.0,
            activeBgColors: [
              [Colors.white],
              [Colors.white]
            ],
            activeFgColor: Colors.white,
            inactiveBgColor:
                ((index == 1) ? Colors.green : Colors.grey),
            inactiveFgColor: Colors.white,
            initialLabelIndex: index,
            totalSwitches: 2,
            labels: [' ', ' '],
            radiusStyle: true,
            onToggle: onToggle,
          ),
          flex: 1,
        ),
        Expanded(
          child: new SizedBox(width: 70),
          flex: 2,
        ),
      ],
    );
  }
}
