import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcalc_tn/constants.dart';
import 'package:hexcalc_tn/engine.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultEvent  {
  var eventType;
  ResultEvent (this.eventType);
}

StreamController changeController = StreamController<ResultEvent>();

// ignore: must_be_immutable
class ResultsArea extends StatefulWidget {
  late Engine engine;


  ResultsArea(Engine engine) {
    this.engine = engine;
  }

  @override
  _ResultsAreaState createState() => _ResultsAreaState(engine);

  void fromEngine() {
    changeController.sink.add(ResultEvent("fromEngine"));
  }
}

class _ResultsAreaState extends State<ResultsArea> {
  _ResultsAreaState(Engine engine) {
    this.engine = engine;
  }

  late Engine engine;

  // for results copy
  var _panPositionXResult = [0.0, 0.0, 0.0, 0.0];

  var _results = ["0", "0", "0", "0"];
  int _resultLines = 4;

  void _loadEngine() async {
    final prefs = await SharedPreferences.getInstance();
    var packed = prefs.getString('engine') ?? "";
    engine.unpack(packed);
    _fromEngine();
  }

  void _saveEngine() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('engine', this.engine.pack());
  }

  void _fromEngine() async {
    setState(() {
      var index = 0;
      while (index < _results.length) {
        _results[index] = this.engine.stack[index++];
      }
      _resultLines = this.engine.resultLines;
      _saveEngine();
    });
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
        var value = this.engine.processCopy(lineNum);
        await Clipboard.setData(ClipboardData(text: value));
        _clearPan();
      }
    } else {
      _clearPan();
    }
  }

  void _onResultCopy(int lineNum) async {
    var value = this.engine.processCopy(lineNum);
    await Clipboard.setData(ClipboardData(text: value));
    _clearPan();
  }

  Future<void> _onResult1DoubleTap() async {
    Clipboard.getData(Clipboard.kTextPlain).then((value) {
      var newValue = value!.text!;
      if (this.engine.processPaste(newValue)) {
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

  @override
  initState() {
    super.initState();
    _loadEngine();
    changeController.stream.listen((e) {
      this._fromEngine();
    });
  }

  @override
  Widget build(BuildContext context) {

    var colWidgets = <Widget>[];

    var deviceSize = MediaQuery.of(context).size;
    var resultStyle = kResultTextStyle;
    if (deviceSize.height < 700) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: colWidgets,
    );
  }
}
