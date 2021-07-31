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
  var lastOp = "";
  var inputLimit = 20;

  var stack = List.generate(4, (index) => "0");
  var memory = "";

  var grid = List.generate(9, (i) => List.generate(5, (index) => Cell()),
      growable: false);
  int hexX = -1;
  int hexY = -1;
  int decX = -1;
  int decY = -1;
  int octX = -1;
  int octY = -1;
  int binX = -1;
  int binY = -1;
  int equalX = -1;
  int equalY = -1;
  int zerozeroX = -1;
  int zerozeroY = -1;
  int mplusX = -1;
  int mplusY = -1;
  int mminusX = -1;
  int mminusY = -1;
  int minX = -1;
  int minY = -1;
  int mrX = -1;
  int mrY = -1;
  int mcX = -1;
  int mcY = -1;
  int shlX = -1;
  int shlY = -1;
  int shrX = -1;
  int shrY = -1;
  int rolX = -1;
  int rolY = -1;
  int rorX = -1;
  int rorY = -1;
  int modX = -1;
  int modY = -1;
  int negX = -1;
  int negY = -1;
  int notX = -1;
  int notY = -1;
  int andX = -1;
  int andY = -1;
  int xorX = -1;
  int xorY = -1;
  int orX = -1;
  int orY = -1;

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
  var decimalPoints = 4;

  var editing = false;

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
    hexX = row;
    hexY = col;
    col++;
    grid[row][col] = new Cell(
        label: "DEC",
        style: kDarkLabelTextStyle,
        halfHeight: true,
        background: kBlueColor,
        gradient: false);
    decX = row;
    decY = col;
    col++;
    grid[row][col] = new Cell(
        label: "OCT",
        style: kBlueLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    octX = row;
    octY = col;
    col++;
    grid[row][col] = new Cell(
        label: "BIN",
        style: kBlueLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    binX = row;
    binY = col;
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
    mplusX = row;
    mplusY = col;
    col++;
    grid[row][col] = new Cell(
        label: "M-",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    mminusX = row;
    mminusY = col;
    col++;
    grid[row][col] = new Cell(
        label: "M in",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    minX = row;
    minY = col;
    col++;
    grid[row][col] = new Cell(
        label: "MR",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    mrX = row;
    mrY = col;
    col++;
    grid[row][col] = new Cell(
        label: "MC",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    mcX = row;
    mcY = col;
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(
        label: "SHL",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    shlX = row;
    shlY = col;
    col++;
    grid[row][col] = new Cell(
        label: "SHR",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    shrX = row;
    shrY = col;
    col++;
    grid[row][col] = new Cell(
        label: "ROL",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    rolX = row;
    rolY = col;
    col++;
    grid[row][col] = new Cell(
        label: "ROR",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    rorX = row;
    rorY = col;
    col++;
    grid[row][col] = new Cell(
        label: "MOD",
        style: kLabelTextStyle,
        halfHeight: true,
        background: kBlueColor);
    modX = row;
    modY = col;
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
    negX = row;
    negY = col;
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
    notX = row;
    notY = col;
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
    andX = row;
    andY = col;
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
    xorX = row;
    xorY = col;
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
    orX = row;
    orY = col;
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
    zerozeroX = row;
    zerozeroY = col;
    col++;
    grid[row][col] = new Cell(label: "=", background: kOrangeColor, flex: 2);
    equalX = row;
    equalY = col;
    col++;
    grid[row][col] = new Cell(label: "", flex: 0);
    col++;
  }

  //
  // pack/unpack
  //
  String pack() {
    String result = "VER "+kVersion+";"; // match with unpack()
    for (var value in stack) {
      result += value + ";";
    }
    result += memory + ";";
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
    result += decimalPoints.toString() + ";";
    return result;
  }

  void unpack(String packed) {
    if (packed.length == 0) return;

    var parts = packed.split(";");
    int index = 0;
    if (parts[index++] != ("VER "+kVersion)) return; // match with pack()

    for (int i = 0; i < stack.length; i++) {
      stack[i] = parts[index++];
    }
    memory = parts[index++];
    mode = parts[index++];
    numberBits = int.parse(parts[index++]);
    numberSigned = parts[index++] == "true";
    keyClick = parts[index++] == "true";
    sounds = parts[index++] == "true";
    backspaceCE = parts[index++] == "true";
    dozonal = parts[index++] == "true";
    operatorPrec = parts[index++] == "true";

    resultLines = int.parse(parts[index++]);
    rpn = parts[index++] == "true";
    floatingPoint = parts[index++] == "true";
    decimalPoints = int.parse(parts[index++]);

    applyMode("HEX"); // HACK: force update
  }

  bool isModeKey(String key) {
    var labels = ["HEX", "DOZ", "DEC", "OCT", "BIN"];
    return labels.contains(key);
  }

  bool isHexKey(String key) {
    var labels = [
      "F",
      "E",
      "D",
      "C",
      "B",
      "A",
      "9",
      "8",
      "7",
      "6",
      "5",
      "4",
      "3",
      "2",
      "1",
      "0",
      "00"
    ];
    return labels.contains(key);
  }

  bool isDozKey(String key) {
    var labels = [
      "B",
      "A",
      "9",
      "8",
      "7",
      "6",
      "5",
      "4",
      "3",
      "2",
      "1",
      "0",
      "00"
    ];
    return labels.contains(key);
  }

  bool isDecKey(String key) {
    var labels = ["9", "8", "7", "6", "5", "4", "3", "2", "1", "0", "00", "."];
    return labels.contains(key);
 }

  bool isOctKey(String key) {
    var labels = ["7", "6", "5", "4", "3", "2", "1", "0", "00"];
    return labels.contains(key);
  }

  bool isBinKey(String key) {
    var labels = ["1", "0", "00"];
    return labels.contains(key);
  }

  bool isNumKey(String key) {
    return isHexKey(key) || isDecKey(key);
  }

  bool isMemKey(String key) {
    var labels = ["M+", "M-", "M in", "MR", "MC"];
    return labels.contains(key);
  }

  bool isStackKey(String key) {
    var labels = ["PUSH", "DROP", "ROT", "SWAP"];
    return labels.contains(key);
  }

  bool isOp1param(String key) {
    var labels = [
      "SHL",
      "SHR",
      "ROL",
      "ROR",
      "NEG",
      "+/-",
      "NOT",
    ];
    return labels.contains(key);
  }

  bool isOp2params(String key) {
    var labels = [
      "MOD",
      "/",
      "AND",
      "x",
      "XOR",
      "-",
      "OR",
      "+"
    ];
    return labels.contains(key);
  }

  bool isEqual(String key) {
    var labels = ["=", "enter"];
    return labels.contains(key);
  }

  bool isBitOp(String key) {
    var labels = [
      "SHL",
      "SHR",
      "ROL",
      "ROR",
      "MOD",
      "NEG",
      "+/-",
      "NOT",
      "AND",
      "XOR",
      "OR"
    ];
    return labels.contains(key);
  }

  bool isMathOp(String key) {
    var labels = ["/", "x", "-", "+"];
    return labels.contains(key);
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

  int get0x7F() {
    var temp = 0x7fffffff;
    switch (numberBits) {
      case 8:
        temp = 0x7f;
        break;
      case 12:
        temp = 0x7ff;
        break;
      case 16:
        temp = 0x7fff;
        break;
      case 24:
        temp = 0x7fffff;
        break;
      case 32:
        temp = 0x7fffffff;
        break;
      case 48:
        temp = 0x7fffffffffff;
        break;
      // case 64:
      //   temp = 0x7fffffffffffffff;
      //   break;
    }
    return temp;
  }

  int get0x80() {
    // 8 bit -> 0x100 = 1 << (8-1)
    var temp = (1 << (numberBits - 1));
    return temp;
  }

  int get0x100() {
    // 8 bit -> 0x100 = 1 << 8
    var temp = (1 << (numberBits));
    return temp;
  }

  int lineToValue(String line) {
    if (line == "") return 0;
    int result = 0;
    if (!floatingPoint) {
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
    }
    return result;
  }

  String valueToLine(int value) {
    var result = "";
    if (!floatingPoint) {
      switch (mode) {
        case "HEX":
          result = BigInt.from(value).toUnsigned(numberBits).toRadixString(16);
          break;
        case "DOZ":
          result = BigInt.from(value).toUnsigned(numberBits).toRadixString(12);
          break;
        case "DEC":
          if (numberSigned)
            result = BigInt.from(value).toSigned(numberBits).toRadixString(10);
          else
            result = BigInt.from(value).toUnsigned(numberBits).toRadixString(10);
          break;
        case "OCT":
          result = BigInt.from(value).toUnsigned(numberBits).toRadixString(8);
          break;
        case "BIN":
          result = BigInt.from(value).toUnsigned(numberBits).toRadixString(2);
          break;
      }
      result = result.toUpperCase();
    }
    return result;
  }

  double lineToValueFP(String line) {
    if (line == "") return 0.0;
    double result = 0;
    if (floatingPoint && numberSigned) {
      switch (mode) {
        case "DEC":
          result = double.parse(line);
          break;
      }
    }
    return result;
  }

  String valueToLineFP(double value) {
    var result = "";
    if (floatingPoint && numberSigned) {
      switch (mode) {
        case "DEC":
          if (numberSigned)
            result = value.toStringAsFixed(decimalPoints);
          break;
      }
      result = result.toUpperCase();
    }
    return result;
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

  void pushStack(String value) {
    int i;
    for (i = stack.length-1; i > 0; i--) {
      stack[i] = stack[i-1];
    }
    stack[i] = value;
  }

  String popStack() {
    var result = stack[0];
    int i;
    for (i = 0; i < stack.length - 1; i++) {
      stack[i] = stack[i+1];
    }
    stack[i] = "0";
    return result;
  }

  void rotateStack() {
    var temp = stack[0];
    int i;
    for (i = 0; i < stack.length - 1; i++) {
      stack[i] = stack[i+1];
    }
    stack[i] = temp;
  }

  void swapStack() {
    var temp = stack[0];
    stack[0] = stack[1];
    stack[1] = temp;
  }

  void processEdit(String key) {
    if (isNumKey(key)) {
      var current = stack[0];
      if (!editing) {
        current = "";
        pushStack(current);
      }
      editing = true;

      // print(key);
      // print(inputLimit);
      // print("---");
      if (current.length < inputLimit) {
        if (current.length == 1 && current[0] == '0') {
          current = key;
        } else {
          current = current + key;
        }
      }
      stack[0] = current;
    } else {
      editing = false;
    }
  }

  void processOpUnary(String key) {
    int temp;
    if (isOp1param(key)) {
      if (!floatingPoint) {
        int value = lineToValue(stack[0]);
        switch (key) {
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
            temp = temp & get0x80();
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
            value = -1 * value;
            value = value & get0xFF();
            break;
          case "NOT":
            value = ~value;
            value = value & get0xFF();
            break;
        }
        clearActive(lastOp);
        stack[0] = valueToLine(value);
      }

      if (floatingPoint) {
        double value = lineToValueFP(stack[0]);
        switch (key) {
          case "+/-":
            value = -1 * value;
            break;
        }
        clearActive(lastOp);
        stack[0] = valueToLineFP(value);
      }
    }
  }

  void processLastOp() {
    if (lastOp.length == 0) return;
    if (!floatingPoint) {
      int value0 = lineToValue(popStack());
      int value1 = lineToValue(popStack());
      switch (lastOp) {
        case "MOD":
          value0 = value1 % value0;
          value0 = value0 & get0xFF();
          break;
        case "AND":
          value0 = value1 & value0;
          value0 = value0 & get0xFF();
          break;
        case "OR":
          value0 = value1 | value0;
          value0 = value0 & get0xFF();
          break;
        case "XOR":
          value0 = value1 ^ value0;
          value0 = value0 & get0xFF();
          break;
        case "/":
          if (value0 != 0) {
            value0 = value1 ~/ value0;
            value0 = value0 & get0xFF();
          }
          break;
        case "x":
          value0 = value1 * value0;
          value0 = value0 & get0xFF();
          break;
        case "+":
          value0 = value1 + value0;
          value0 = value0 & get0xFF();
          break;
        case "-":
          value0 = value1 - value0;
          value0 = value0 & get0xFF();
          break;
        default:
          break;
      }
      clearActive(lastOp);
      print(value0);
      pushStack(valueToLine(value0));    
    }

    if (floatingPoint) {
      double value0 = lineToValueFP(popStack());
      double value1 = lineToValueFP(popStack());
      switch (lastOp) {
        case "/":
          if (value0 != 0) {
            value0 = value1 / value0;
          }
          break;
        case "x":
          value0 = value1 * value0;
          break;
        case "+":
          value0 = value1 + value0;
          break;
        case "-":
          value0 = value1 - value0;
          break;
        default:
          break;
      }
      clearActive(lastOp);
      print(value0);
      pushStack(valueToLineFP(value0));    
    }
  }

  void processOps(String key) {
    if (isOp2params(key)) {
      if (rpn) {
        lastOp = key;
        processLastOp();
      } else {
        if (lastOp.length > 0) {
          // this is !precidence or 1+2x3=7, or (1+2)x3, instead of 1+2x3=9
          processLastOp();
        }
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
  }

  void processEquals(String key) {
    if (key == "=" && lastOp != "") {
      processLastOp();
    }
    if (key == "enter") {
      pushStack(stack[0]);
    }
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
          if (current[0] == '-') current = "0";
        }
        stack[0] = current;
      } else {
        stack[0] = "0";
      }
    }
  }

  String processCopy(int lineNum) {
    return stack[lineNum - 1];
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

  bool processPaste(String svalue) {
    try {
      if (svalue.length > 0) {
        lineToValue(svalue);
        lineToValueFP(svalue);
        stack[0] = svalue;
      }
    } catch (exception) {
      return false;
    }
    return true;
  }

  void applyMode(String currentKey) {
    // optimize numbers
    if (isNumKey(currentKey) || isOp1param(currentKey)|| isOp2params(currentKey)) {
      return;
    }

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
          } else if (key == "HEX" && mode == "DOZ") {
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
      }
    }

    // based on rpn and float, adjust labels (will need to parse for these labels)
    grid[hexX][hexY].label = (dozonal ? "DOZ" : "HEX");
    grid[equalX][equalY].label = (rpn ? "enter" : "=");
    grid[mplusX][mplusY].label = (rpn ? "PUSH" : "M+");
    grid[mminusX][mminusY].label = (rpn ? "DROP" : "M-");
    grid[minX][minY].label = (rpn ? "ROT" : "M in");
    grid[mrX][mrY].label = (rpn ? "SWAP" : "MR");
    grid[mcX][mcY].label = (rpn ? " " : "MC");

    grid[zerozeroX][zerozeroY].label = (floatingPoint ? "." : "00");
    grid[negX][negY].label = (floatingPoint ? "+/-" : "NEG");
    grid[hexX][hexY].disabled = (floatingPoint ? true : false);
    grid[octX][octY].disabled = (floatingPoint ? true : false);
    grid[binX][binY].disabled = (floatingPoint ? true : false);
    grid[shlX][shlY].disabled = (floatingPoint ? true : false);
    grid[shrX][shrY].disabled = (floatingPoint ? true : false);
    grid[rolX][rolY].disabled = (floatingPoint ? true : false);
    grid[rorX][rorY].disabled = (floatingPoint ? true : false);
    grid[modX][modY].disabled = (floatingPoint ? true : false);
    grid[notX][notY].disabled = (floatingPoint ? true : false);
    grid[andX][andY].disabled = (floatingPoint ? true : false);
    grid[xorX][xorY].disabled = (floatingPoint ? true : false);
    grid[orX][orY].disabled = (floatingPoint ? true : false);

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
    }
  }

  void processMem(String key) {
    if (isMemKey(key)) {
      if (!floatingPoint) {
        int value1 = lineToValue(memory);
        int value2 = lineToValue(stack[0]);
        switch (key) {
          case "M+":
            value1 += value2;
            memory = valueToLine(value1);
            break;
          case "M-":
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

      if (floatingPoint) {
        double value1 = lineToValueFP(memory);
        double value2 = lineToValueFP(stack[0]);
        switch (key) {
          case "M+":
            value1 += value2;
            memory = valueToLineFP(value1);
            break;
          case "M-":
            value1 -= value2;
            memory = valueToLineFP(value1);
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
  }

  void processStack(String key) {
     if (isStackKey(key)) {
      switch (key) {
        case "PUSH":
          pushStack(stack[0]);
          break;
        case "DROP":
          popStack();
          break;
        case "ROT":
          rotateStack();
          break;
        case "SWAP":
          swapStack();
          break;
      }
    }
  }

  //
  // Public methods
  //

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
    if (grid[x][y].disabled) return;
    var key = grid[x][y].label;
    processEdit(key);
    processOpUnary(key);
    processOps(key);
    processEquals(key);
    processAC(key);
    processCE(key);
    processMem(key);
    processStack(key);
    processMode(key);
    applyMode(key);
  }
}
