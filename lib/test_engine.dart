import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcalc_tn/constants.dart';
import 'package:hexcalc_tn/components/calc_button.dart';
import 'package:hexcalc_tn/engine.dart';

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
    this.background = Colors.black,
    this.gradient = true,
    this.flex = 1,
    this.disabled = false,
    this.active = false,
  });
}

class TestEngine {
  var grid = List.generate(2, (i) => List.generate(5, (index) => Cell()),
      growable: false);

  bool recording = false;

  late BuildContext context;

  late Timer _testTimer;
  bool _testTimerRunning = false;
  late int _testCount = 0;

  var recorded = [];

  TestEngine() {
    int row = 0;
    int col = 0;
    grid[row][col] = new Cell(
        label: "",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kBlackColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kBlackColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kBlackColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kBlackColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kBlackColor,
        gradient: false);
    col++;
    row++;
    col = 0;
    grid[row][col] = new Cell(
        label: "TEST",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "REC",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "STOP",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "PLAY",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    grid[row][col] = new Cell(
        label: "CLIP",
        style: kMedLabelTextStyle,
        halfHeight: true,
        background: kDarkColor,
        gradient: false);
    col++;
    row++;
  }

  void showWarningDialog(String message, Function? onPress) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NOTICE'),
          content: new Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                onPress!();
              },
            ),
          ],
        );
      },
    );
  }

  void showWarningDialogAndResponse(String message, Function? onPress) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('WARNING'),
          content: new Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                onPress!(false);
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                onPress!(true);
              },
            ),
          ],
        );
      },
    );
  }

  String buildEntry(String key, List<String> stack) {
    var entry = "";
    entry += key;
    entry += ": ";
    for (var i = 0; i < stack.length; i++) {
      entry += stack[i];
      if (i + 1 < stack.length) entry += ", ";
    }
    print(entry);
    return entry;
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

  void clearRecorded() {
    recorded = [];
  }

  String getRecorded() {
    String result = "";
    for (var i = 0; i < recorded.length; i++) {
      result += "\"" + recorded[i] + "\",\n";
    }
    return result;
  }

  //
  // Public methods
  //

  void setContext(BuildContext context) {
    this.context = context;
  }

  void addGrid(
      List<Widget> colWidgets, int rowOffset, notifyEngine(int x, int y)) {
    for (var i = 0; i < grid.length; i++) {
      var rowWidgets = <Widget>[];
      for (var j = 0; j < grid[0].length; j++) {
        var label = getLabel(i, j);
        var style = getStyle(i, j);
        var disabled = grid[i][j].disabled;
        if (disabled) {
          style = style.copyWith(color: kLightColor);
        }
        var background = grid[i][j].background;
        var gradient = grid[i][j].gradient;
        var flex = grid[i][j].flex;
        // build onpress function that calls engine with closure
        var onPress = () {
          notifyEngine(i + rowOffset, j);
        };
        if (flex > 0) {
          rowWidgets.add(
            new Expanded(
              child: CalcButton(
                onPress: onPress,
                color: background,
                margin: EdgeInsets.fromLTRB(0, 0, 2, 2),
                portrait: true,
                gradient: gradient,
                disabled: disabled,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      label,
                      style: style,
                    ),
                  ],
                ),
              ),
              flex: flex,
            ),
          );
        }
      }
      var row = new Row(children: rowWidgets);
      var container = new Container(
        height: kMainColumnHeightPortrait / 2,
        child: row,
      );
      colWidgets.add(container);
    }
  }

  void processKey(String key, List<String> stack) {
    if (recording) {
      var entry = buildEntry(key, stack);
      recorded.add(entry);
    }
  }

  void processKeyAndConfig(String key, Engine engine) {
    List<String> stack = [];
    stack.add((engine.rpn ? "rpn" : "norm"));
    stack.add((engine.floatingPoint ? "float" : "int"));
    stack.add(engine.decimalPoints.toString());
    stack.add(engine.numberBits.toString());
    stack.add((engine.numberSigned ? "signed" : "unsigned"));
    if (recording) {
      var entry = buildEntry(key, stack);
      recorded.add(entry);
    }
  }

  void runTestEngine(int x, int y, Engine engine, notifyEngine(int x, int y),
      onDoneTestEngine()) async {
    if (x >= engine.grid.length) {
      var key = grid[x - engine.grid.length][y].label;
      //print(key);
      switch (key) {
        case "TEST":
          showWarningDialogAndResponse("Will run automated tests, continue?",
              (bool choice) {
            if (choice) {
              clearRecorded();
              this._testTimer =
                  Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
                if (this._testCount >= tests.length) {
                  this._testTimer.cancel();
                  _testTimerRunning = false;
                  showWarningDialog(
                      "Completed  " + _testCount.toString() + " tests.", () {});
                  _testCount = 0;
                  return;
                }
                print("test timer: " + this._testCount.toString());
                var line = tests[this._testCount];
                var parts = line.split(":");
                var a, b;
                var found = false;
                for (var i = 0; i < engine.grid.length && !found; i++) {
                  for (var j = 0; j < engine.grid[0].length && !found; j++) {
                    if (engine.grid[i][j].label == parts[0]) {
                      a = i;
                      b = j;
                      found = true;
                    }
                  }
                }
                if (parts[0] == "?") {
                  try {
                    // "?: norm, int, 4, 32, unsigned",
                    var subparts = parts[1].split(",");
                    engine.rpn = ((subparts[0].trim() == "rpn") ? true : false);
                    engine.floatingPoint =
                        ((subparts[1].trim() == "float") ? true : false);
                    engine.decimalPoints = int.parse(subparts[2]);
                    engine.numberBits = int.parse(subparts[3]);
                    engine.numberSigned =
                        ((subparts[1].trim() == "signed") ? true : false);
                    //HACK
                    onDoneTestEngine();
                  } catch (e) {}
                } else if (a == null || b == null) {
                  this._testTimer.cancel();
                  _testTimerRunning = false;
                  showWarningDialog(
                      "Completed  " +
                          _testCount.toString() +
                          " tests. Failed! \n expected: " +
                          line +
                          "\n but key not found! ",
                      () {});
                  _testCount = 0;
                } else {
                  notifyEngine(a, b);
                  var temp = buildEntry(parts[0], engine.stack);
                  if (temp != line) {
                    this._testTimer.cancel();
                    _testTimerRunning = false;
                    showWarningDialog(
                        "Completed  " +
                            _testCount.toString() +
                            " tests. Failed! \n expected: " +
                            line +
                            "\n got expected: " +
                            temp,
                        () {});
                    _testCount = 0;
                    return;
                  }
                }

                this._testCount++;
              });
              _testTimerRunning = true;
            }
          });
          break;
        case "REC":
          showWarningDialogAndResponse("Will record key enyties, continue?",
              (bool choice) {
            if (choice) {
              recording = true;
              // start recording with config and AC
              processKeyAndConfig("?", engine);
              notifyEngine(engine.acX, engine.acY);
              notifyEngine(engine.mcX, engine.mcY);
            }
          });
          break;
        case "STOP":
          recording = false;
          if (_testTimerRunning) {
            this._testTimer.cancel();
            _testTimerRunning = false;
            _testCount = 0;
          }
          showWarningDialog("Test or Recording stopped.", () {});
          break;
        case "PLAY":
          showWarningDialog("TDB - Playback current recording?.", () {});
          break;
        case "CLIP":
          await Clipboard.setData(ClipboardData(text: getRecorded()));
          showWarningDialog(
              "Recorded keys copied to clipboard. Email to development team.",
              () {});
          break;
      }
      return;
    }
    return;
  }

  var tests = [
    "?: norm, int, 4, 32, unsigned",
    "AC: 0, 0, 0, 0",
    "MC: 0, 0, 0, 0",
    "1: 1, 0, 0, 0",
    "+: 1, 0, 0, 0",
    "2: 2, 1, 0, 0",
    "=: 3, 0, 0, 0",
    "AC: 0, 0, 0, 0",
    "4: 4, 0, 0, 0",
    "+: 4, 0, 0, 0",
    "5: 5, 4, 0, 0",
    "=: 9, 0, 0, 0",
    "6: 6, 9, 0, 0",
    "-: 6, 9, 0, 0",
    "5: 5, 6, 9, 0",
    "=: 1, 9, 0, 0",
    "AC: 0, 0, 0, 0",
    "7: 7, 0, 0, 0",
    "-: 7, 0, 0, 0",
    "8: 8, 7, 0, 0",
    "=: 4294967295, 0, 0, 0",
    "9: 9, 4294967295, 0, 0",
    "-: 9, 4294967295, 0, 0",
    "8: 8, 9, 4294967295, 0",
    "=: 1, 4294967295, 0, 0",
    "?: norm, int, 4, 32, unsigned",
    "AC: 0, 0, 0, 0",
    "MC: 0, 0, 0, 0",
    "1: 1, 0, 0, 0",
    "+: 1, 0, 0, 0",
    "2: 2, 1, 0, 0",
    "=: 3, 0, 0, 0",
    "?: rpn, int, 4, 32, unsigned",
    "?: rpn, int, 4, 32, unsigned",
    "4: 4, 3, 0, 0",
    "enter: 4, 4, 3, 0",
    "2: 2, 4, 4, 3",
    "+: 6, 4, 3, 0",
  ];
}
