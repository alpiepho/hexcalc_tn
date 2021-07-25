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
  bool active;

  Cell({
    this.label = '',
    this.style = kNumberTextStyle,
    this.halfHeight = false,
    this.background = Colors.grey,
    this.gradient = true,
    this.flex = 1,
    this.disabled = false,
    this.active = false,
  });
}

class Engine {
  static const KEY_HEX = "HEX";

  var lastOp = "";
  var inputLimit = 20;

  var stack = List.generate(4, (index) => "0");
  var memory = "";

  var grid = List.generate(9, (i) => List.generate(5, (index) => Cell()),
      growable: false);

  var mode = "DEC";
  var numberBits = 32; // 8, 12, 16, 24, 32, 48,   not supported in pwa: 64
  var numberSigned = false;
  var keyClick = false;
  var sounds = false;
  var backspaceCE = true;
  var dozonal = false; // base12
  var operatorPrec = true; // 1+2x3=7 instead of 9

  var resultLines = 1;
  var rpn = false;
  var floatingPoint = false;

  Engine() {
    for (int i = 0; i < stack.length; i++) {
      stack[i] = "0";
    }
    int row = 0;
    int col = 0;
    // NOTE: if you change a key string, look for other references (cleaner than creating 50 const)
    grid[row][col] = new Cell(
        label: "HEX",
        style: kBlueLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "DEC",
        style: kDarkLabelTextStyle,
        halfHeight: true,
        background: kBlueColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "OCT",
        style: kBlueLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "BIN",
        style: kBlueLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "?",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(
        label: "M+",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "M-",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "M in",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "MR",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "MC",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(
        label: "SHL",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "SHR",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "ROL",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "ROR",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    grid[row][col] = new Cell(
        label: "MOD",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "D", disabled: true);
    col++;
    grid[row][col] = new Cell(label: "E", disabled: true);
    col++;
    grid[row][col] = new Cell(label: "F", disabled: true);
    col++;
    grid[row][col] = new Cell(label: "NEG", style: kLabelTextStyle);
    col++;
    grid[row][col] = new Cell(label: "AC", background: kRedColor);
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "A", disabled: true);
    col++;
    grid[row][col] = new Cell(label: "B", disabled: true);
    col++;
    grid[row][col] = new Cell(label: "C", disabled: true);
    col++;
    grid[row][col] = new Cell(label: "NOT", style: kLabelTextStyle);
    col++;
    grid[row][col] = new Cell(label: "/");
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "7");
    col++;
    grid[row][col] = new Cell(label: "8");
    col++;
    grid[row][col] = new Cell(label: "9");
    col++;
    grid[row][col] = new Cell(label: "AND", style: kLabelTextStyle);
    col++;
    grid[row][col] = new Cell(label: "x", style: kLabelTextStyle);
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "4");
    col++;
    grid[row][col] = new Cell(label: "5");
    col++;
    grid[row][col] = new Cell(label: "6");
    col++;
    grid[row][col] = new Cell(label: "XOR", style: kLabelTextStyle);
    col++;
    grid[row][col] = new Cell(label: "-");
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "1");
    col++;
    grid[row][col] = new Cell(label: "2");
    col++;
    grid[row][col] = new Cell(label: "3");
    col++;
    grid[row][col] = new Cell(label: "OR", style: kLabelTextStyle);
    col++;
    grid[row][col] = new Cell(label: "+");
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(label: "CE", background: kGreenColor);
    col++;
    grid[row][col] = new Cell(label: "0");
    col++;
    grid[row][col] = new Cell(label: "00");
    col++;
    grid[row][col] = new Cell(label: "=", background: kOrangeColor, flex: 2);
    col++;
    grid[row][col] = new Cell(label: "", flex: 0);
    col++;
  }

  //
  // pack/unpack
  //
  String pack() {
    String result = "";
    for (var value in stack) {
      result += value + ";";
    }
    result += mode + ";";
    result += numberBits.toString() + ";";
    result += numberSigned.toString() + ";";
    result += keyClick.toString() + ";";
    result += sounds.toString() + ";";
    result += backspaceCE.toString() + ";";
    result += dozonal.toString() + ";";
    result += operatorPrec.toString() + ";";

    result += resultLines.toString() + ";";
    result += rpn.toString() + ";";
    result += floatingPoint.toString() + ";";
    return result;
  }

  void unpack(String packed) {
    if (packed.length == 0) return;

    var parts = packed.split(";");
    int index = 0;
    for (int i = 0; i < stack.length; i++) {
      stack[i] = parts[index++];
    }
    numberBits = int.parse(parts[index++]);
    mode = parts[index++];
    numberSigned = parts[index++] == "true";
    keyClick = parts[index++] == "true";
    sounds = parts[index++] == "true";
    backspaceCE = parts[index++] == "true";
    dozonal = parts[index++] == "true";
    operatorPrec = parts[index++] == "true";

    resultLines = int.parse(parts[index++]);
    rpn = parts[index++] == "true";
    floatingPoint = parts[index++] == "true";
  }

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
    switch (key) {
      case "HEX":
      case "DOZ":
      case "DEC":
      case "OCT":
      case "BIN":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isHexKey(String key) {
    bool result;
    switch (key) {
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
      case "00":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isDozKey(String key) {
    bool result;
    switch (key) {
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
      case "00":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isDecKey(String key) {
    bool result;
    switch (key) {
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
      case "00":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isOctKey(String key) {
    bool result;
    switch (key) {
      case "7":
      case "6":
      case "5":
      case "4":
      case "3":
      case "2":
      case "1":
      case "0":
      case "00":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isBinKey(String key) {
    bool result;
    switch (key) {
      case "1":
      case "0":
      case "00":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isNumKey(String key) {
    return isHexKey(key);
  }

  bool isMemKey(String key) {
    bool result;
    switch (key) {
      case "M+":
      case "M-":
      case "M in":
      case "MR":
      case "MC":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isOp(String key) {
    bool result;
    switch (key) {
      case "SHL":
      case "SHR":
      case "ROL":
      case "ROR":
      case "MOD":
      case "NEG":
      case "NOT":
      case "/":
      case "AND":
      case "x":
      case "XOR":
      case "-":
      case "OR":
      case "+":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isEqual(String key) {
    bool result;
    switch (key) {
      case "=":
      case "enter":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isUnaryOp(String key) {
    bool result;
    switch (key) {
      case "SHL":
      case "SHR":
      case "ROL":
      case "ROR":
      case "NEG":
      case "NOT":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isBitOp(String key) {
    bool result;
    switch (key) {
      case "SHL":
      case "SHR":
      case "ROL":
      case "ROR":
      case "MOD":
      case "NEG":
      case "NOT":
      case "AND":
      case "XOR":
      case "OR":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  bool isMathOp(String key) {
    bool result;
    switch (key) {
      case "/":
      case "x":
      case "-":
      case "+":
        result = true;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  int lineToValue(String line) {
    int result = 0;

    switch (mode) {
      case "HEX":
        result = int.parse(line, radix: 16);
        break;
      case "DOZ":
        result = int.parse(line, radix: 12);
        break;
      case "DEC":
        result = int.parse(line, radix: 10);
        break;
      case "OCT":
        result = int.parse(line, radix: 8);
        break;
      case "BIN":
        result = int.parse(line, radix: 2);
        break;
    }

    return result;
  }

  String valueToLine(int value) {
    var result = "";

    switch (mode) {
      case "HEX":
        result = value.toRadixString(16);
        break;
      case "DOZ":
        result = value.toRadixString(12);
        break;
      case "DEC":
        result = value.toRadixString(10);
        break;
      case "OCT":
        result = value.toRadixString(8);
        break;
      case "BIN":
        result = value.toRadixString(2);
        break;
    }
    result = result.toUpperCase();

    return result;
  }

  int get0xFF() {
    var temp = 0xffffffff;
    switch (numberBits) {
      case 8:
        temp = 0xff;
        break;
      case 12:
        temp = 0xfff;
        break;
      case 16:
        temp = 0xffff;
        break;
      case 24:
        temp = 0xffffff;
        break;
      case 32:
        temp = 0xffffffff;
        break;
      case 48:
        temp = 0xffffffffffff;
        break;
      // case 64:
      //   temp = 0xffffffffffffffff;
      //   break;
    }
    return temp;
  }

  int get0x10() {
    var temp = (1 << (numberBits - 1));
    return temp;
  }

  void setActive(String key) {
    for (int x = 0; x < grid.length; x++) {
      for (int y = 0; y < grid[0].length; y++) {
        if (key == grid[x][y].label) {
          grid[x][y].active = true;
        }
      }
    }
    lastOp = "";  
  }

  void clearActive(String key) {
    for (int x = 0; x < grid.length; x++) {
      for (int y = 0; y < grid[0].length; y++) {
        if (key == grid[x][y].label) {
          grid[x][y].active = false;
        }
      }
    }
    lastOp = "";  
  }

  void processEdit(String key) {
    if (isNumKey(key)) {
      var current = stack[0];
      if (current.length < inputLimit) {
        if (current.length == 1 && current[0] == '0') {
          current = key;
        } else {
          current = current + key;
        }
      }
      stack[0] = current;
    }
  }

  void processOps(String key) {
    if (isOp(key)) {
      lastOp = key;
      for (int x = 0; x < grid.length; x++) {
        for (int y = 0; y < grid[0].length; y++) {
          if (key == grid[x][y].label) {
            grid[x][y].active = true;
          }
        }
      }
    }
  }

  void processOpUnary() {
    int temp;
    if (isUnaryOp(lastOp)) {
      int value = lineToValue(stack[0]);
      switch (lastOp) {
        case "SHL":
          value = value << 1;
          value = value & get0xFF();
          break;
        case "SHR":
          value = value >> 1;
          value = value & get0xFF();
          break;
        case "ROL":
          temp = value & get0xFF();
          temp = temp & get0x10();
          temp = temp >> (numberBits - 1);
          value = value << 1;
          value = value & get0xFF();
          value += temp;
          break;
        case "ROR":
          temp = (value & 1);
          temp = temp << (numberBits - 1);
          value = value >> 1;
          value = value & get0xFF();
          value += temp;
          value = value & get0xFF();
          break;
        case "NEG":
          // TODO fix neg
          value = -1 * value;
          value = value & get0xFF();
          break;
        case "NOT":
          value = ~value;
          value = value & get0xFF();
          break;
      }
      clearActive(lastOp);
      print(value);
      stack[0] = valueToLine(value);
    }
  }

  void processEquals(String key) {
    // TODO finish processEquals
    if (key == "=" && lastOp != "") {
      clearActive(lastOp);
    }
    if (key == "enter") {}

  }

  void processAC(String key) {
    if (key == "AC") {
      for (int i = 0; i < stack.length; i++) {
        stack[i] = "0";
      }
    }
  }

  void processCE(String key) {
    if (key == "CE") {
      if (backspaceCE) {
        var current = stack[0];
        if (current.length == 1) {
          current = "0";
        } else {
          current = current.substring(0, current.length - 1);
        }
        stack[0] = current;
      } else {
        stack[0] = "0";
      }
    }
  }

  String processCopy4() {
    return stack[3];
  }

  String processCopy3() {
    return stack[2];
  }

  String processCopy2() {
    return stack[1];
  }

  String processCopy1() {
    return stack[0];
  }

  void processPaste(String value) {
    if (value.length > 0) stack[0] = value;
  }

  void applyMode() {
    int equalX = -1;
    int equalY = -1;
    int zerozeroX = -1;
    int zerozeroY = -1;
    for (int x = 0; x < grid.length; x++) {
      for (int y = 0; y < grid[0].length; y++) {
        var key = grid[x][y].label;
        // based on mode highlight appropriate mode key
        if (isModeKey(key)) {
          grid[x][y].style = kBlueLabelTextStyle;
          grid[x][y].background = kDarkColor;
          if (key == mode) {
            grid[x][y].style = kDarkLabelTextStyle;
            grid[x][y].background = kBlueColor;
          } else if (key == mode) {
            grid[x][y].style = kDarkLabelTextStyle;
            grid[x][y].background = kBlueColor;
          } else if (key == mode) {
            grid[x][y].style = kDarkLabelTextStyle;
            grid[x][y].background = kBlueColor;
          } else if (key == mode) {
            grid[x][y].style = kDarkLabelTextStyle;
            grid[x][y].background = kBlueColor;
          } else if (key == mode) {
            grid[x][y].style = kDarkLabelTextStyle;
            grid[x][y].background = kBlueColor;
          }
        }

        // based on mode, disable appropriate keys
        grid[x][y].disabled = false;
        if (isNumKey(key)) {
          grid[x][y].disabled = true;
          if (mode == "HEX" && isHexKey(key))
            grid[x][y].disabled = false;
          else if (mode == "DOZ" && isDozKey(key))
            grid[x][y].disabled = false;
          else if (mode == "DEC" && isDecKey(key))
            grid[x][y].disabled = false;
          else if (mode == "OCT" && isOctKey(key))
            grid[x][y].disabled = false;
          else if (mode == "BIN" && isBinKey(key)) grid[x][y].disabled = false;
        }

        // get x,y for special keys
        if (key == "=" || key == "enter") {
          equalX = x;
          equalY = y;
        }
        if (key == "00" || key == ".") {
          zerozeroX = x;
          zerozeroY = y;
        }
      }
    }

    // based on rpn and float, adjust labels (will need to parse for these labels)
    grid[equalX][equalY].label = (rpn ? "enter" : "=");
    grid[zerozeroX][zerozeroY].label = (floatingPoint ? "." : "00");
  }

  void processMode(String key) {
    if (isModeKey(key)) {
      var currentMode = mode;

      // change result lines
      for (int i = 0; i < stack.length; i++) {
        int value = lineToValue(stack[i]);
        mode = key;
        stack[i] = valueToLine(value);
        mode = currentMode;
      }

      // set new mode
      mode = key;

      // recalculate input string limit
      // limit based on mode and numberBits
      // ie: FFFFFFFF FFFFFFFF == 18446744073709551615 decimal, 20 digits
      var temp = get0xFF();
      var line = valueToLine(temp);
      inputLimit = line.length;
      //print(line);
      //print(inputLimit);
    }
  }

  void processMem(String key) {
    if (isMemKey(key)) {
      switch (key) {
        case "M+":
          int value1 = lineToValue(memory);
          int value2 = lineToValue(stack[0]);
          value1 += value2;
          memory = valueToLine(value1);
          break;
        case "M-":
          int value1 = lineToValue(memory);
          int value2 = lineToValue(stack[0]);
          value1 -= value2;
          memory = valueToLine(value1);
          break;
        case "M in":
          memory = stack[0];
          setActive("MR");
          break;
        case "MR":
        if (memory.length > 0) stack[0] = memory;
          break;
        case "MC":
          memory = "";
          clearActive("MR");
          break;
      }
    }
  }

  //
  // Public methods
  //

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
    var style = grid[x][y].style;
    if (grid[x][y].active) {
      style = grid[x][y].style.copyWith(color: Colors.yellow);
    }
    return style;
  }

  void processKey(int x, int y) {
    var key = grid[x][y].label;
    processEdit(key);
    processOps(key);
    processOpUnary();
    processEquals(key);
    processAC(key);
    processCE(key);
    processMem(key);
    processMode(key);
    applyMode();
  }
}
