import 'package:flutter/material.dart';
import 'package:hexcalc_tn/constants.dart';


class Cell {
  String label;
  TextStyle style;
  bool halfHeight;
  Color background;
  bool gradient;
  int flex;
  bool disabled;
  // int outlineCount = 0;

  Cell(
    { 
      this.label = '',
      this.style = kNumberTextStyle,
      this.halfHeight = false,
      this.background = Colors.grey,
      this.gradient = true,
      this.flex = 1,
      this.disabled = false,
    }
  );



}
class Engine {
  // Color colorTextLeft = Colors.black;
  // Color colorBackgroundLeft = Colors.grey;
  // Color colorTextRight = Colors.black;
  // Color colorBackgroundRight = Colors.blueAccent;

  // String labelLeft = "Will Be";
  // String labelRight = "RPN HexCalc";
  // int valueLeft = 0;
  // int valueRight = 0;

  // bool earnedEnabled = false;
  // bool earnedVisible = false;
  // int earnedLeft = 0;
  // int earnedRight = 0;

  // String newLabelLeft = "";
  // String newLabelRight = "";
  // int newValueLeft = 0;
  // int newValueRight = 0;
  // Color newColorTextLeft = Colors.black;
  // Color newColorBackgroundLeft = Colors.red;
  // Color newColorTextRight = Colors.black;
  // Color newColorBackgroundRight = Colors.blueAccent;

  // FontTypes fontType = FontTypes.system;

  bool forceLandscape = false;
  // bool notify7Enabled = false;
  // bool notify8Enabled = false;
  // bool lastPointLeft = false;
  // bool lastPointEnabled = false;

  int rows = 9;
  int cols = 5;
  var grid = List.generate(9, (i) => List.generate(5, (index) => Cell()), growable: false);

  Engine() {
    int row = 0;
    int col = 0;
    grid[row][col] = new Cell(label: "HEX", style: kBlueLabelTextStyle, halfHeight: true, background: kDarkColor, gradient: false); col++;
    grid[row][col] = new Cell(label: "DEC", style: kDarkLabelTextStyle, halfHeight: true, background: kBlueColor, gradient: false); col++;
    grid[row][col] = new Cell(label: "OCT", style: kBlueLabelTextStyle, halfHeight: true, background: kDarkColor, gradient: false); col++;
    grid[row][col] = new Cell(label: "BIN", style: kBlueLabelTextStyle, halfHeight: true, background: kDarkColor, gradient: false); col++;
    grid[row][col] = new Cell(label: "?", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "M+", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "M-", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "M in", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "MR", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "MC", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "SHL", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "SHR", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "ROL", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "ROR", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    grid[row][col] = new Cell(label: "MOD", style: kLabelTextStyle, halfHeight: true, background: kBlueColor); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "D", disabled: true); col++;
    grid[row][col] = new Cell(label: "E", disabled: true); col++;
    grid[row][col] = new Cell(label: "F", disabled: true); col++;
    grid[row][col] = new Cell(label: "NEG", style: kLabelTextStyle); col++;
    grid[row][col] = new Cell(label: "AC", background: kRedColor); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "A", disabled: true); col++;
    grid[row][col] = new Cell(label: "B", disabled: true); col++;
    grid[row][col] = new Cell(label: "C", disabled: true); col++;
    grid[row][col] = new Cell(label: "NOT", style: kLabelTextStyle); col++;
    grid[row][col] = new Cell(label: "/"); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "7"); col++;
    grid[row][col] = new Cell(label: "8"); col++;
    grid[row][col] = new Cell(label: "9"); col++;
    grid[row][col] = new Cell(label: "AND", style: kLabelTextStyle); col++;
    grid[row][col] = new Cell(label: "x"); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "4"); col++;
    grid[row][col] = new Cell(label: "5"); col++;
    grid[row][col] = new Cell(label: "6"); col++;
    grid[row][col] = new Cell(label: "XOR", style: kLabelTextStyle); col++;
    grid[row][col] = new Cell(label: "-"); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "1"); col++;
    grid[row][col] = new Cell(label: "2"); col++;
    grid[row][col] = new Cell(label: "3"); col++;
    grid[row][col] = new Cell(label: "OR", style: kLabelTextStyle); col++;
    grid[row][col] = new Cell(label: "+"); col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "CE", background: kGreenColor); col++;
    grid[row][col] = new Cell(label: "0"); col++;
    grid[row][col] = new Cell(label: "00"); col++;
    grid[row][col] = new Cell(label: "=", background: kOrangeColor, flex: 2); col++;
    grid[row][col] = new Cell(label: "", flex: 0); col++;
  }

  //
  // pack/unpack
  //
  String pack() {
    String result = "";

    // result += colorTextLeft.toString() + ";";
    // result += colorBackgroundLeft.toString() + ";";
    // result += colorTextRight.toString() + ";";
    // result += colorBackgroundRight.toString() + ";";

    // result += labelLeft.toString() + ";";
    // result += labelRight.toString() + ";";
    // result += valueLeft.toString() + ";";
    // result += valueRight.toString() + ";";

    // result += earnedEnabled.toString() + ";";
    // result += earnedVisible.toString() + ";";
    // result += earnedLeft.toString() + ";";
    // result += earnedRight.toString() + ";";

    // result += fontType.toString() + ";";

    result += forceLandscape.toString() + ";";
    // result += notify7Enabled.toString() + ";";
    // result += notify8Enabled.toString() + ";";

    // result += lastPointLeft.toString() + ";";
    // result += lastPointEnabled.toString() + ";";

    return result;
  }

  int getRows() {
    return grid.length;
  }

    int getCols() {
    return grid[0].length;
  }

  String getLabel(int x, int y) {
    return grid[x][y].label;
  }

  TextStyle getStyle(int x, int y) {
    return grid[x][y].style;
  }

  // Color stringToColor(String code) {
  //   // .... Color(0xff000000)
  //   var parts = code.split("0x");
  //   var s = parts[1].substring(0, 8);
  //   var h = int.parse(s, radix: 16);
  //   return new Color(h);
  // }

  void unpack(String packed) {
    if (packed.length == 0)
      return;

    var parts = packed.split(";");
    int index = 0;

    // colorTextLeft = stringToColor(parts[index++]);
    // colorBackgroundLeft = stringToColor(parts[index++]);
    // colorTextRight = stringToColor(parts[index++]);
    // colorBackgroundRight = stringToColor(parts[index++]);

    // labelLeft = parts[index++];
    // labelRight = parts[index++];
    // valueLeft = int.parse(parts[index++]);
    // valueRight = int.parse(parts[index++]);

    // earnedEnabled = parts[index++] == "true";
    // earnedVisible = parts[index++] == "true";
    // earnedLeft = int.parse(parts[index++]);
    // earnedRight = int.parse(parts[index++]);

    // fontType = FontTypes.system;
    // for (var value in FontTypes.values) {
    //   if (value.toString() == parts[index]) {
    //     fontType = value;
    //     break;
    //   }
    // }
    // index++;

    forceLandscape = parts[index++] == "true";
    // notify7Enabled = parts[index++] == "true";
    // notify8Enabled = parts[index++] == "true";

    // lastPointLeft = parts[index++] == "true";
    // lastPointEnabled = parts[index++] == "true";

    // colorTextLeft = colorTextLeft;
    // colorBackgroundLeft = colorBackgroundLeft;
    // colorTextRight = colorTextRight;
    // colorBackgroundRight = colorBackgroundRight;

    // newColorTextLeft = colorTextLeft;
    // newColorBackgroundLeft = colorBackgroundLeft;
    // newColorTextRight = colorTextRight;
    // newColorBackgroundRight = colorBackgroundRight;

  }

  // //
  // // Getter/Setters for temporary variables
  // //
  // set newValueLeftString(String text) {
  //   if (text.isNotEmpty) {
  //     newValueLeft = int.parse(text);
  //     if (newValueLeft < 0) newValueLeft = 0;
  //   }
  // }

  // set newValueRightString(String text) {
  //   if (text.isNotEmpty) {
  //     newValueRight = int.parse(text);
  //     if (newValueRight < 0) newValueRight = 0;
  //   }
  // }

  // //
  // // Public methods
  // //

  // String getLabelLeft() {
  //   String result = labelLeft;
  //   if (lastPointEnabled) {
  //     if ((valueLeft > 0 || valueRight > 0) && lastPointLeft) {
  //       result = labelLeft + " >";
  //     }
  //   }
  //   return result;
  // }

  // String getLabelRight() {
  //   String result = labelRight;
  //   if (lastPointEnabled) {
  //     if ((valueLeft > 0 || valueRight > 0) && !lastPointLeft) {
  //       result = "< " + labelRight;
  //     }
  //   }
  //   return result;
  // }

  // void incrementLeft(bool earned) {
  //   valueLeft += 1;
  //   lastPointLeft = true;
  //   if (earned) {
  //     earnedLeft += 1;
  //   }
  // }

  // void decrementLeft(bool earned) {
  //   valueLeft -= 1;
  //   if (valueLeft < 0) valueLeft = 0;
  //   if (earned) {
  //     earnedLeft -= 1;
  //     if (earnedLeft < 0) earnedLeft = 0;
  //   }
  // }

  // void incrementRight(bool earned) {
  //   valueRight += 1;
  //   lastPointLeft = false;
  //   if (earned) {
  //     earnedRight += 1;
  //   }
  // }

  // void decrementRight(bool earned) {
  //   valueRight -= 1;
  //   if (valueRight < 0) valueRight = 0;
  //   if (earned) {
  //     earnedRight -= 1;
  //     if (earnedRight < 0) earnedRight = 0;
  //   }
  // }

  // void clearBoth() {
  //   valueLeft = 0;
  //   valueRight = 0;
  //   earnedLeft = 0;
  //   earnedRight = 0;
  //   lastPointLeft = false;
  // }

  // void resetBoth()  {
  //   labelLeft = "Away";
  //   labelRight = "Home";
  //   valueLeft = 0;
  //   valueRight = 0;
  //   earnedLeft = 0;
  //   earnedRight = 0;
  //   lastPointLeft = false;
  //   colorTextLeft = Colors.black;
  //   colorBackgroundLeft = Colors.red;
  //   colorTextRight = Colors.black;
  //   colorBackgroundRight = Colors.blueAccent;
  //   newColorTextLeft = colorTextLeft;
  //   newColorBackgroundLeft = colorBackgroundLeft;
  //   newColorTextRight = colorTextRight;
  //   newColorBackgroundRight = colorBackgroundRight;
  //   fontType = FontTypes.system;
  // }

  // void swapTeams() {
  //   var valueTemp = valueLeft;
  //   valueLeft = valueRight;
  //   valueRight = valueTemp;
  //   valueTemp = earnedLeft;
  //   earnedLeft = earnedRight;
  //   earnedRight = valueTemp;
  //   lastPointLeft = !lastPointLeft;
  //   var labelTemp = labelLeft;
  //   labelLeft = labelRight;
  //   labelRight = labelTemp;
  //   var colorTemp = colorTextLeft;
  //   colorTextLeft = colorTextRight;
  //   colorTextRight = colorTemp;
  //   colorTemp = colorBackgroundLeft;
  //   colorBackgroundLeft = colorBackgroundRight;
  //   colorBackgroundRight = colorTemp;
  // }

  // void saveBoth() {
  //   labelLeft = newLabelLeft;
  //   labelRight = newLabelRight;
  //   valueLeft = newValueLeft;
  //   valueRight = newValueRight;
  //   colorTextLeft = newColorTextLeft;
  //   colorBackgroundLeft = newColorBackgroundLeft;
  //   colorTextRight = newColorTextRight;
  //   colorBackgroundRight = newColorBackgroundRight;
  // }

  // void setNew() {
  //   newLabelLeft = labelLeft;
  //   newLabelRight = labelRight;
  //   newValueLeft = valueLeft;
  //   newValueRight = valueRight;
  //   newColorTextLeft = colorTextLeft;
  //   newColorBackgroundLeft = newColorBackgroundLeft;
  //   newColorBackgroundRight = newColorBackgroundRight;
  // }

  // bool notify7() {
  //   if (notify7Enabled) {
  //     if (((valueLeft + valueRight) % 7) == 0)
  //       return true;
  //   }
  //   return false;
  // }

  // bool notify8() {
  //   if (notify8Enabled) {
  //     if (valueLeft == 8 || valueRight == 8)
  //       return true;
  //   }
  //   return false;
  // }
}
