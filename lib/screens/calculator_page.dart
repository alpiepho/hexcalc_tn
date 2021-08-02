import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcalc_tn/components/calc_button.dart';
import 'package:hexcalc_tn/components/settings_modal.dart';
import 'package:hexcalc_tn/constants.dart';
import 'package:hexcalc_tn/engine.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // for results copy
  var _panPositionXResult = [0.0, 0.0, 0.0, 0.0];

  var _results = ["0", "0", "0", "0"];
  int _resultLines = 4;

  Engine _engine = Engine();

  void _loadEngine() async {
    final prefs = await SharedPreferences.getInstance();
    var packed = prefs.getString('engine') ?? "";
    _engine.unpack(packed);
    _fromEngine();
  }

  void _saveEngine() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('engine', _engine.pack());
  }

  void _fromEngine() async {
    setState(() {
      var index = 0;
      while (index < _results.length) {
        _results[index] = this._engine.stack[index++];
      }
      _resultLines = this._engine.resultLines;
      _saveEngine();
    });
  }

  void _onDone() async {
    this._engine.applyMode("HEX");  // HACK: force update
    _fromEngine();
    Navigator.of(context).pop();
  }

  void _clearPan() {
      for (int i = 0; i < _panPositionXResult.length; i++) {
        _panPositionXResult[i] = 0.0;
      }
  }

  void _onResultSwipe(int lineNum, DragUpdateDetails details) async {
    if (details.delta.dx.abs() > 1) {
      _panPositionXResult[lineNum-1] += details.delta.dx;
      if (_panPositionXResult[lineNum-1].abs() > 30) {
        var value = this._engine.processCopy(lineNum);
        await Clipboard.setData(ClipboardData(text: value));
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResultCopy(int lineNum) async {
    var value = this._engine.processCopy(lineNum);
    await Clipboard.setData(ClipboardData(text: value));
    _clearPan();
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
      colWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => {_onResultCopy(4)},
            child: new Icon(
              Icons.copy, 
              color: Colors.white10,
              //size: 10,
            ),
          ),
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) => {_onResultSwipe(4, details)},
            child: Text(
              _results[3],
              style: resultStyle,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ));
    }
    if (_resultLines >= 3) {
      colWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => {_onResultCopy(3)},
            child: new Icon(
              Icons.copy, 
              color: Colors.white10,
              //size: 10,
            ),
          ),
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) => {_onResultSwipe(3, details)},
            child: Text(
              _results[2],
              style: resultStyle,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ));
    }
    if (_resultLines >= 2) {
      colWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => {_onResultCopy(2)},
            child: new Icon(
              Icons.copy, 
              color: Colors.white10,
              //size: 10,
            ),
          ),
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) => {_onResultSwipe(2, details)},
            onDoubleTap: _onResult1DoubleTap,
            child: Text(
              _results[1],
              style: resultStyle,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ));
    }
    colWidgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => {_onResultCopy(1)},
          child: new Icon(
            Icons.copy, 
            color: Colors.white10,
            //size: 10,
          ),
        ),
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) => {_onResultSwipe(1, details)},
          onDoubleTap: _onResult1DoubleTap,
          child: Text(
            _results[0],
            style: resultStyle,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ));
    colWidgets.add(SizedBox(
      height: 10,
    ));

    // build the buttons
    for (var i = 0; i < this._engine.grid.length; i++) {
      var rowWidgets = <Widget>[];
      for (var j = 0; j < this._engine.grid[0].length; j++) {
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
