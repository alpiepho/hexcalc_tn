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

  var stack = List.generate(10, (index) => "0");
  int stackPointer = 0;
  
  var grid = List.generate(9, (i) => List.generate(5, (index) => Cell()), growable: false);

  Engine() {
    for (int i = 0; i < stack.length; i++) {
      stack[i] = "0";
    }
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
    for (var value in stack) {
      result += value + ";";
    }
    result += stackPointer.toString() + ";";

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

  void unpack(String packed) {
    if (packed.length == 0)
      return;

    var parts = packed.split(";");
    int index = 0;
    for (int i = 0; i < stack.length; i++) {
      stack[i] = parts[index++];
    }
    stackPointer = int.parse(parts[index++]);
  }

  //
  // Public methods
  //

  void processKey(int x, int y) {
    var msg = "ENGINE: " + x.toString() + "," + y.toString() + " " + grid[x][y].label;
    if (stackPointer < stack.length) {
      print(msg);
      stack[stackPointer++] = grid[x][y].label;
    }

    // TODO finish ops
    if (grid[x][y].label == "AC") {
      for (int i = 0; i < stack.length; i++) {
        stack[i] = "0";
      }
      stackPointer = 0;
    }
  }

}
