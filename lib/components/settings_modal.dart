import 'package:flutter/material.dart';
import 'package:hexcalc_tn/constants.dart';
import 'package:hexcalc_tn/engine.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toggle_switch/toggle_switch.dart';

// ignore: must_be_immutable
class SettingsModal extends StatefulWidget {
  late BuildContext context;
  late Engine engine;
  late Function onDone;

  SettingsModal(
      BuildContext context,
      Engine engine,
       Function onDone
      ) {
    this.context = context;
    this.engine = engine;
    this.onDone = onDone;

  }

  @override
  _SettingsModal createState() => _SettingsModal(context, engine, onDone);
}

class _SettingsModal extends State<SettingsModal> {

  _SettingsModal(
      BuildContext context,
      Engine engine,
      Function onDone
      ) {
    this.context = context;
    this.engine = engine;
    this.onDone = onDone;
    this._keyClickIndex = 0;
    this._soundsIndex = 0;
    this._backspaceIndex = 0;
    this._dozenalIndex = 0;
    this._precedenceIndex = 0;
  }

  late BuildContext context;
  late Engine engine;
  late Function onDone;
  late int _keyClickIndex;
  late int _soundsIndex;
  late int _backspaceIndex;
  late int _dozenalIndex;
  late int _precedenceIndex;

  late var selectedRate;
  late List<String> allRates;

  void resultLinesToggle(int index) {
    this.engine.resultLines = index + 1;
  }

  void onBitsToggle(int index) {
      switch (index) {
        case 0:  this.engine.numberBits = 8; break;
        case 1:  this.engine.numberBits = 12; break;
        case 2:  this.engine.numberBits = 16; break;
        case 3:  this.engine.numberBits = 24; break;
        case 4:  this.engine.numberBits = 32; break;
        case 5:  this.engine.numberBits = 48; break;
        default:  
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('WARNING'),
                content: new Text("64 bit not supported, will revert to 32"),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Done'),
                    onPressed: () {
                      this.engine.numberBits = 32;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          break;
      }
  }

  void onSignedToggle(int index) {
      switch (index) {
        case 1:  this.engine.numberSigned = true; break;
        default:  this.engine.numberSigned = false; break;
      }
  }

  void keyClickToggle(int index) {
      switch (index) {
        case 1:  this.engine.keyClick = true; break;
        default:  this.engine.keyClick = false; break;
      }
      setState(() {
        this._keyClickIndex = index;
      });
  }

  void soundToggle(int index) {
      switch (index) {
        case 1:  this.engine.sounds = true; break;
        default:  this.engine.sounds = false; break;
      }
      setState(() {
        this._soundsIndex = index;
      });
  }

  void backspaceToggle(int index) {
      switch (index) {
        case 1:  this.engine.backspaceCE = true; break;
        default:  this.engine.backspaceCE = false; break;
      }
      setState(() {
        this._backspaceIndex = index;
      });
  }

  void dozenalToggle(int index) {
      switch (index) {
        case 1:  this.engine.dozonal = true; break;
        default:  this.engine.dozonal = false; break;
      }
      setState(() {
        this._dozenalIndex = index;
      });
  }

  void precedenceToggle(int index) {
      switch (index) {
        case 1:  this.engine.operatorPrec = true; break;
        default:  this.engine.operatorPrec = false; break;
      }
      setState(() {
        this._precedenceIndex = index;
      });
  }

  void onHelp() async {
    launch('https://github.com/alpiepho/hexcalc_tn/blob/master/README.md');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    var rowsIndex = this.engine.resultLines -1;

    var bitIndex = 4;
    switch (this.engine.numberBits) {
      case 8: bitIndex = 0; break;
      case 12: bitIndex = 1; break;
      case 16: bitIndex = 2; break;
      case 24: bitIndex = 3; break;
      case 32: bitIndex = 4; break;
      case 48: bitIndex = 5; break;
      case 64: bitIndex = 6; break;
    }

    var signedIndex = 0;
    switch (this.engine.numberSigned) {
      case false: signedIndex = 0; break;
      case true: signedIndex = 1; break;
    }

    switch (this.engine.keyClick) {
      case false: this._keyClickIndex = 0; break;
      case true: this._keyClickIndex = 1; break;
    }

    switch (this.engine.sounds) {
      case false: this._soundsIndex = 0; break;
      case true: this._soundsIndex = 1; break;
    }

    switch (this.engine.backspaceCE) {
      case false: this._backspaceIndex = 0; break;
      case true: this._backspaceIndex = 1; break;
    }

    switch (this.engine.dozonal) {
      case false: this._dozenalIndex = 0; break;
      case true: this._dozenalIndex = 1; break;
    }

    switch (this.engine.operatorPrec) {
      case false: this._precedenceIndex = 0; break;
      case true: this._precedenceIndex = 1; break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kSettingsModalBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        toolbarHeight: 50,
        titleSpacing: 20,
        title: Text("Settings"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: onDone as void Function()?,
        ),
      ),
      body: Container(
        width: kMainContainerWidthPortrait,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                new SizedBox(height: kSettingsSizedBoxHeight),
                new Text(
                  "Result Lines", 
                  textAlign: TextAlign.center,
                ),
                new SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new SizedBox(width: 50),
                    ToggleSwitch(
                      minWidth: 50.0,
                      minHeight: 30.0,
                      fontSize: 10.0,
                      initialLabelIndex: rowsIndex,
                      activeBgColor: [ Colors.grey.shade400 ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 4,
                      labels: ['1', '2', '3', '4'],
                      onToggle: resultLinesToggle,
                    ),
                  ],
                ),

                Divider(
                  height: 20.0,
                  thickness: 2.0,
                ),


                new SizedBox(height: kSettingsSizedBoxHeight),
                new Text(
                  "Number of Bits", 
                  textAlign: TextAlign.center,
                ),
                new SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new SizedBox(width: 50),
                    ToggleSwitch(
                      minWidth: 50.0,
                      minHeight: 30.0,
                      fontSize: 10.0,
                      initialLabelIndex: bitIndex,
                      activeBgColor: [ Colors.grey.shade400 ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 7,
                      labels: ['8', '12', '16', '24', '32', '48', '64'],
                      onToggle: onBitsToggle,
                    ),
                  ],
                ),

                new SizedBox(height: kSettingsSizedBoxHeight),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new SizedBox(width: 50),
                    ToggleSwitch(
                      minWidth: 100.0,
                      minHeight: 30.0,
                      fontSize: 10.0,
                      initialLabelIndex: signedIndex,
                      activeBgColor: [ Colors.grey.shade400 ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: ['UnSigned', 'Signed'],
                      onToggle: onSignedToggle,
                    ),
                  ],
                ),
                new SizedBox(height: kSettingsSizedBoxHeight),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                    ),
                    Expanded(
                      child: new Text(
                        "Key Click", 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 1,
                      ),
                    Expanded (
                      child: ToggleSwitch(
                        minWidth: 30.0,
                        minHeight: 30.0,
                        cornerRadius: 20.0,
                        activeBgColors: [[Colors.white], [Colors.white]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: ((this._keyClickIndex == 1) ? Colors.green : Colors.grey),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: this._keyClickIndex,
                        totalSwitches: 2,
                        labels: [' ', ' '],
                        radiusStyle: true,
                        onToggle: keyClickToggle,         
                      ),
                      flex: 1,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                      ),
                  ],
                ),

                new SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                    ),
                    Expanded(
                      child: new Text(
                        "Sounds", 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 1,
                      ),
                    Expanded (
                      child: ToggleSwitch(
                        minWidth: 30.0,
                        minHeight: 30.0,
                        cornerRadius: 20.0,
                        activeBgColors: [[Colors.white], [Colors.white]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: ((this._soundsIndex == 1) ? Colors.green : Colors.grey),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: this._soundsIndex,
                        totalSwitches: 2,
                        labels: [' ', ' '],
                        radiusStyle: true,
                        onToggle: soundToggle,         
                      ),
                      flex: 1,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                      ),
                  ],
                ),

                new SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                    ),
                    Expanded(
                      child: new Text(
                        "CE as Backspace", 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 1,
                      ),
                    Expanded (
                      child: ToggleSwitch(
                        minWidth: 30.0,
                        minHeight: 30.0,
                        cornerRadius: 20.0,
                        activeBgColors: [[Colors.white], [Colors.white]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: ((this._backspaceIndex == 1) ? Colors.green : Colors.grey),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: this._backspaceIndex,
                        totalSwitches: 2,
                        labels: [' ', ' '],
                        radiusStyle: true,
                        onToggle: backspaceToggle,         
                      ),
                      flex: 1,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                      ),
                  ],
                ),

                new SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                    ),
                    Expanded(
                      child: new Text(
                        "Enable Dozenal (Base 12)", 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 1,
                      ),
                    Expanded (
                      child: ToggleSwitch(
                        minWidth: 30.0,
                        minHeight: 30.0,
                        cornerRadius: 20.0,
                        activeBgColors: [[Colors.white], [Colors.white]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: ((this._dozenalIndex == 1) ? Colors.green : Colors.grey),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: this._dozenalIndex,
                        totalSwitches: 2,
                        labels: [' ', ' '],
                        radiusStyle: true,
                        onToggle: dozenalToggle,         
                      ),
                      flex: 1,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                      ),
                  ],
                ),

                new SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                    ),
                    Expanded(
                      child: new Text(
                        "Operator Precedence", 
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 1,
                      ),
                    Expanded (
                      child: ToggleSwitch(
                        minWidth: 30.0,
                        minHeight: 30.0,
                        cornerRadius: 20.0,
                        activeBgColors: [[Colors.white], [Colors.white]],
                        activeFgColor: Colors.white,
                        inactiveBgColor: ((this._precedenceIndex == 1) ? Colors.green : Colors.grey),
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: this._precedenceIndex,
                        totalSwitches: 2,
                        labels: [' ', ' '],
                        radiusStyle: true,
                        onToggle: precedenceToggle,         
                      ),
                      flex: 1,
                    ),
                    Expanded (
                      child: new SizedBox(width: 70),
                      flex: 2,
                      ),
                  ],
                ),

                Divider(),
                new Text(
                  "If operator precedence is enabled", 
                  textAlign: TextAlign.center,
                ),
                new SizedBox(height: 10),
                new Text(
                  "1 + 2 x 3 = 7 (instead of 9)", 
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 20.0,
                  thickness: 2.0,
                ),
                new Text(
                  "Swipe left/right = Copy to Clipboard", 
                  textAlign: TextAlign.center,
                ),
                new SizedBox(height: 10),
                new Text(
                  "Double Tap = Paste", 
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 20.0,
                  thickness: 2.0,
                ),

                new Text(
                  "UNDER CONSTRUCTION:", 
                  textAlign: TextAlign.center,
                ),
                new SizedBox(height: 10),
                GestureDetector(
                  child: new Text(
                    "https://github.com/alpiepho/hexcalc_tn", 
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: onHelp,
                ),
                new SizedBox(height: kSettingsSizedBoxHeight),

              ],
            ),
      ),
    );
  }
}
