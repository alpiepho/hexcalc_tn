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

  static const KEY_HEX = "HEX";

  var stack = List.generate(10, (index) => "0");
  int stackPointer = 0;
  
  var grid = List.generate(9, (i) => List.generate(5, (index) => Cell()), growable: false);

  var mode = "DEC";

  Engine() {
    for (int i = 0; i < stack.length; i++) {
      stack[i] = "0";
    }
    int row = 0;
    int col = 0;
    // NOTE: if you change a key string, look for other references (cleaner than creating 50 const)
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

    result += mode + ";";

    return result;
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

    mode = parts[index++];
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


  //
  // Public methods
  //

// case "HEX":
// case "DEC":
// case "OCT":
// case "BIN":
// case "?" 
 
// case "M+":
// case "M-":
// case "M in":
// case "MR":
// case "MC":

// case "SHL":
// case "SHR":
// case "ROL":
// case "ROR":
// case "MOD":

// case "D":
// case "E":
// case "F":
// case "NEG":
// case "AC":

// case "A":
// case "B":
// case "C":
// case "NOT":
// case "/":

// case "7":
// case "8":
// case "9":
// case "AND":
// case "x":
 
// case "4":
// case "5":
// case "6":
// case "XOR":
// case "-":

// case "1":
// case "2":
// case "3":
// case "OR":
// case "+":

// case "CE":
// case "0":
// case "00":
// case "=":

  bool isModeKey(String key) {
    bool result;
    switch(key) {
      case "HEX":
      case "DOZ":
      case "DEC":
      case "OCT":
      case "BIN": result = true; break;
      default: result = false; break;
    }
    return result;
  }

  void setMode(String key) {
    if (isModeKey(key)) mode = key;
  }

  bool isHexKey(String key) {
    bool result;
    switch(key) {
      case "F":
      case "E":
      case "D": 
      case "C":
      case "B":
      case "A":
      case "9":
      case "8":
      case "7":
      case "6":
      case "5":
      case "4":
      case "3":
      case "2":
      case "1":
      case "0":
      case "00": result = true; break;
      default: result = false; break;
    }
    return result;
  }

  bool isDozKey(String key) {
    bool result;
    switch(key) {
      case "B":
      case "A":
      case "9":
      case "8":
      case "7":
      case "6":
      case "5":
      case "4":
      case "3":
      case "2":
      case "1":
      case "0":
      case "00": result = true; break;
      default: result = false; break;
    }
    return result;
  }

  bool isDecKey(String key) {
    bool result;
    switch(key) {
      case "9":
      case "8":
      case "7":
      case "6":
      case "5":
      case "4":
      case "3":
      case "2":
      case "1":
      case "0":
      case "00": result = true; break;
      default: result = false; break;
    }
    return result;
  }

  bool isOctKey(String key) {
    bool result;
    switch(key) {
      case "7":
      case "6":
      case "5":
      case "4":
      case "3":
      case "2":
      case "1":
      case "0":
      case "00": result = true; break;
      default: result = false; break;
    }
    return result;
  }

  bool isBinKey(String key) {
    bool result;
    switch(key) {
      case "1":
      case "0":
      case "00": result = true; break;
      default: result = false; break;
    }
    return result;
  }

  bool isNumKey(String key) {
    return isHexKey(key);
  }

  bool isMemKey(String key) {
    bool result;
    switch(key) {
      case "M+":
      case "M-":
      case "M in":
      case "MR":
      case "MC": result = true; break;
      default: result = false; break;
    }
    return result;
  }

  void applyMode() {
    for (int x = 0; x < grid.length; x++) {
      for (int y = 0; y < grid[0].length; y++) {
        var key = grid[x][y].label;
        // based on mode highlight appropriate mode key
         if (isModeKey(key)) {
    // "HEX", style: kBlueLabelTextStyle, background: kDarkColor,
    // "DEC", style: kDarkLabelTextStyle, background: kBlueColor,
    // "OCT", style: kBlueLabelTextStyle, background: kDarkColor,
    // "BIN", style: kBlueLabelTextStyle, background: kDarkColor,
          grid[x][y].style = kBlueLabelTextStyle;
          grid[x][y].background = kDarkColor;
          if (key == mode) { grid[x][y].style = kDarkLabelTextStyle; grid[x][y].background = kBlueColor; }
          else if (key == mode) { grid[x][y].style = kDarkLabelTextStyle; grid[x][y].background = kBlueColor; }
          else if (key == mode) { grid[x][y].style = kDarkLabelTextStyle; grid[x][y].background = kBlueColor; }
          else if (key == mode) { grid[x][y].style = kDarkLabelTextStyle; grid[x][y].background = kBlueColor; }
          else if (key == mode) { grid[x][y].style = kDarkLabelTextStyle; grid[x][y].background = kBlueColor; }
         }

        // based on mode, disable appropriate keys
        grid[x][y].disabled = false;
        if (isNumKey(key)) {
          grid[x][y].disabled = true;
          if (mode == "HEX" && isHexKey(key)) grid[x][y].disabled = false;
          else if (mode == "DOZ" && isDozKey(key)) grid[x][y].disabled = false;
          else if (mode == "DEC" && isDecKey(key)) grid[x][y].disabled = false;
          else if (mode == "OCT" && isOctKey(key)) grid[x][y].disabled = false;
          else if (mode == "BIN" && isBinKey(key)) grid[x][y].disabled = false;
        }
      }
    }
  }

  void processKey(int x, int y) {
    var msg = "ENGINE: " + x.toString() + "," + y.toString() + " " + grid[x][y].label;
    if (stackPointer < stack.length) {
      print(msg);
      stack[stackPointer++] = grid[x][y].label;
    }

    var key = grid[x][y].label;

    // TODO finish ops
    if (key == "AC") {
      for (int i = 0; i < stack.length; i++) {
        stack[i] = "0";
      }
      stackPointer = 0;
    }

    if (isModeKey(key)) {
      setMode(key);
    }

    applyMode();
  }

}
