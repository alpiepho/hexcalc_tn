import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      if (_panPositionXResult4.abs() > 30) {
        var value = this._engine.processCopy4();
        await Clipboard.setData(ClipboardData(text: value));
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResult3Swipe(DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult3 += details.delta.dx;
      if (_panPositionXResult3.abs() > 30) {
        var value = this._engine.processCopy3();
        await Clipboard.setData(ClipboardData(text: value));
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResult2Swipe(DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult2 += details.delta.dx;
      if (_panPositionXResult2.abs() > 30) {
        var value = this._engine.processCopy2();
        await Clipboard.setData(ClipboardData(text: value));
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResult1Swipe(DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult1 += details.delta.dx;
      if (_panPositionXResult1.abs() > 30) {
        var value = this._engine.processCopy1();
        await Clipboard.setData(ClipboardData(text: value));
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  Future<void> _onResult1DoubleTap() async {
    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      var newValue = value!.text!;
      if (this._engine.processPaste(newValue)) {
        _fromEngine();
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ERROR'),
              content: new Text("'" + newValue + "' is not a number."),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );        
      }
    });
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
    if (!isPortrait) {
      return Scaffold(
        backgroundColor: kInputPageBackgroundColor,
        body: Center(
          child: Container(
            width: kMainContainerWidthPortrait,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Text(
                  "Landscape mode is not supported.",
                  style: kLanscapeWarningTextStyle,

                )
              ],
            ),
          ),
        ),
      );
    }

    var colWidgets = <Widget>[];

    var deviceSize = MediaQuery.of(context).size;
    var mainColumnHeightPortrait = kMainColumnHeightPortrait;
    var resultStyle = kResultTextStyle;
    if (deviceSize.height < 700) {
      mainColumnHeightPortrait = kMainColumnHeightPortrait2;
      resultStyle = kResultTextStyle.copyWith(fontSize: 30);
    }

    // build the result lines from last N lines of stack
    if (_resultLines >= 4) {
      colWidgets.add(GestureDetector(
        onPanUpdate: _onResult4Swipe,
        child: Text(
          _result4,
          style: resultStyle,
          textAlign: TextAlign.end,
        ),
      ));
    }
    if (_resultLines >= 3) {
      colWidgets.add(GestureDetector(
        onPanUpdate: _onResult3Swipe,
        child: Text(
          _result3,
          style: resultStyle,
          textAlign: TextAlign.end,
        ),
      ));
    }
    if (_resultLines >= 2) {
      colWidgets.add(GestureDetector(
        onPanUpdate: _onResult2Swipe,
        child: Text(
          _result2,
          style: resultStyle,
          textAlign: TextAlign.end,
        ),
      ));
    }
    colWidgets.add(GestureDetector(
      onPanUpdate: _onResult1Swipe,
      onDoubleTap: _onResult1DoubleTap,
      child: Text(
        _result1,
        style: resultStyle,
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
        height: (this._engine.grid[i][0].halfHeight
            ? mainColumnHeightPortrait / 2
            : mainColumnHeightPortrait),
        child: row,
      );
      colWidgets.add(container);
    }

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
  }
}
