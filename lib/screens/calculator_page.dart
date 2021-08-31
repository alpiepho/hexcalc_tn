import 'package:flutter/material.dart';
import 'package:hexcalc_tn/components/calc_button.dart';
import 'package:hexcalc_tn/components/results_area.dart';
import 'package:hexcalc_tn/components/settings_modal.dart';
import 'package:hexcalc_tn/constants.dart';
import 'package:hexcalc_tn/engine.dart';
import 'package:hexcalc_tn/test_engine.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  Engine _engine = Engine();
  late ResultsArea _resultsArea;

  //DEBUG TESTENGINE
  TestEngine _testEngine = TestEngine();

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
      _saveEngine();
    });
  }

  void _onDone() async {
    //DEBUG TESTENGINE
    this._testEngine.processKeyAndConfig("?", this._engine);
    this._engine.applyMode("HEX");  // HACK: force update
    _fromEngine();
    this._resultsArea.fromEngine();
    Navigator.of(context).pop();
  }
  
  void _notifyEngine(int x, int y) async {
    //DEBUG TESTENGINE
    this._testEngine.runTestEngine(x, y, this._engine, _notifyEngine);
    if (x > this._engine.grid.length) {
      return;
    }

    if(this._engine.processKey(x, y)) {
      // only some keys should cause page to re-build
      _fromEngine();
    }
    // trigger results area to rebuild
    this._resultsArea.fromEngine();

    //DEBUG TESTENGINE
    this._testEngine.processKey(this._engine.grid[x][y].label, this._engine.stack);
  }

  @override
  initState() {
    super.initState();
    _loadEngine();

    //DEBUG TESTENGINE
    _testEngine.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    //print("calc build");
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
    if (deviceSize.height < 700) {
      mainColumnHeightPortrait = kMainColumnHeightPortrait2;
    }

    _resultsArea = ResultsArea(this._engine);
    colWidgets.add(_resultsArea);

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

    //DEBUG TESTENGINE
    this._testEngine.addGrid(colWidgets, this._engine.grid.length, _notifyEngine);

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
