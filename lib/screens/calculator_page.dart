import 'package:flutter/material.dart';
import 'package:hexcalc_tn/components/calc_button.dart';
import 'package:hexcalc_tn/components/settings_modal.dart';
import 'package:hexcalc_tn/constants.dart';
import 'package:hexcalc_tn/engine.dart';

// import 'package:shared_preferences/shared_preferences.dart';
class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // for results copy
  double _panPositionXResult4 = 0.0;
  double _panPositionXResult3 = 0.0;
  double _panPositionXResult2 = 0.0;
  double _panPositionXResult1 = 0.0;
  String _copyValue = "";

  String _result4 = "0";
  String _result3 = "0";
  String _result2 = "0";
  String _result1 = "0";
  int _resultLines = 4;

  Engine _engine = Engine();

  void _loadEngine() async {
    // final prefs = await SharedPreferences.getInstance();
    // var packed = prefs.getString('engine') ?? "";
    // _engine.unpack(packed);
    _fromEngine();
  }

  void _saveEngine() async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('engine', _engine.pack());
  }

  void _fromEngine() async {
    setState(() {
      var index = 0;
      _result1 = this._engine.stack[index++];
      _result2 = this._engine.stack[index++];
      _result3 = this._engine.stack[index++];
      _result4 = this._engine.stack[index++];
      _resultLines = this._engine.resultLines;
      _saveEngine();
    });
  }

  void _onDone() async {
    this._engine.applyMode();
    _fromEngine();
    Navigator.of(context).pop();
  }

  void _clearPan() {
      _panPositionXResult4 = 0.0;
      _panPositionXResult3 = 0.0;
      _panPositionXResult2 = 0.0;
      _panPositionXResult1 = 0.0;
  }

  void _onResult4Swipe(DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult4 += details.delta.dx;
      if (_panPositionXResult4 < -30) {
        _copyValue = this._engine.processCopy4();
        _clearPan();
      } else if (_panPositionXResult4 > 30) {
        _copyValue = this._engine.processCopy4();
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResult3Swipe(DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult3 += details.delta.dx;
      if (_panPositionXResult3 < -30) {
        _copyValue = this._engine.processCopy3();
        _clearPan();
      } else if (_panPositionXResult3 > 30) {
        _copyValue = this._engine.processCopy3();
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResult2Swipe(DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult2 += details.delta.dx;
      if (_panPositionXResult2 < -30) {
        _copyValue = this._engine.processCopy2();
        _clearPan();
      } else if (_panPositionXResult2 > 30) {
        _copyValue = this._engine.processCopy2();
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResult1Swipe(DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult1 += details.delta.dx;
      if (_panPositionXResult1 < -30) {
        _copyValue = this._engine.processCopy1();
        _clearPan();
      } else if (_panPositionXResult1 > 30) {
        _copyValue = this._engine.processCopy1();
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResult1DoubleTap() {
    print("double tap");
    print(_copyValue);
    this._engine.processPaste(_copyValue);
    _copyValue = "";
    _fromEngine();
  }

  void _notifyEngine(int x, int y) async {
    this._engine.processKey(x, y);
    _fromEngine();
  }

  @override
  initState() {
    super.initState();
    _loadEngine();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var forcePortrait = isPortrait;

    var colWidgets = <Widget>[];

    // build the result lines from last N lines of stack
    if (_resultLines >= 4) {
      colWidgets.add(GestureDetector(
        onPanUpdate: _onResult4Swipe,
        child: Text(
          _result4,
          style: kResultTextStyle,
          textAlign: TextAlign.end,
        ),
      ));
    }
    if (_resultLines >= 3) {
      colWidgets.add(GestureDetector(
        onPanUpdate: _onResult3Swipe,
        child: Text(
          _result3,
          style: kResultTextStyle,
          textAlign: TextAlign.end,
        ),
      ));
    }
    if (_resultLines >= 2) {
      colWidgets.add(GestureDetector(
        onPanUpdate: _onResult2Swipe,
        child: Text(
          _result2,
          style: kResultTextStyle,
          textAlign: TextAlign.end,
        ),
      ));
    }
    colWidgets.add(GestureDetector(
      onPanUpdate: _onResult1Swipe,
      onDoubleTap: _onResult1DoubleTap,
      child: Text(
        _result1,
        style: kResultTextStyle,
        textAlign: TextAlign.end,
      ),
    ));
    colWidgets.add(SizedBox(
      height: 10,
    ));

    // build the buttons
    for (var i = 0; i < this._engine.getRows(); i++) {
      var rowWidgets = <Widget>[];
      for (var j = 0; j < this._engine.getCols(); j++) {
        var label = this._engine.getLabel(i, j);
        var style = this._engine.getStyle(i, j);
        var disabled = this._engine.grid[i][j].disabled;
        if (disabled) {
          style = style.copyWith(color: kLightColor);
        }
        var background = this._engine.grid[i][j].background;
        var gradient = this._engine.grid[i][j].gradient;
        var flex = this._engine.grid[i][j].flex;
        // build onpress function that calls engine with closure
        var onPress = () {
          _notifyEngine(i, j);
        };
        if (label == "?") {
          // replace press onPress with settings page call
          onPress = () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return SettingsModal(
                  context,
                  this._engine,
                  _onDone,
                );
              },
              isScrollControlled: true,
            );
          };
        }
        if (flex > 0) {
          rowWidgets.add(
            new Expanded(
              child: CalcButton(
                onPress: onPress,
                color: background,
                margin: EdgeInsets.fromLTRB(0, 0, 2, 2),
                portrait: forcePortrait,
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
        height: (this._engine.grid[i][0].halfHeight
            ? kMainColumnHeightPortrait / 2
            : kMainColumnHeightPortrait),
        child: row,
      );
      colWidgets.add(container);
    }

    // if (isPortrait) {
    return Scaffold(
      backgroundColor: kInputPageBackgroundColor,
      body: Center(
        child: Container(
          width: kMainContainerWidthPortrait,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: colWidgets,
          ),
        ),
      ),
    );
    // }
    // else {
    // }
  }
}
