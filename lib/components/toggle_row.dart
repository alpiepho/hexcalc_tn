import 'package:flutter/material.dart';
// import 'package:hexcalc_tn/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';


class ToggleRow extends StatelessWidget {
  ToggleRow({
    required this.minWidth,
    required this.index, 
    required this.labels,
    required this.onToggle});

  double minWidth;
  final int index;
  final List<String> labels;
  final Function(int) onToggle;

  @override
  Widget build(BuildContext context) {
    var total = labels.length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new SizedBox(width: 10),
        ToggleSwitch(
          minWidth: minWidth,
          minHeight: 30.0,
          fontSize: 10.0,
          initialLabelIndex: index,
          activeBgColor: [Colors.grey.shade400],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          totalSwitches: total,
          labels: labels,
          onToggle: onToggle,
        ),
      ],
    );
  }
}
