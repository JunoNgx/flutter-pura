import 'package:flutter/material.dart';

import 'package:wallpaper/services/confirm_action.dart';
import 'package:wallpaper/widgets/confirmation_dialog.dart';
import 'package:wallpaper/widgets/reset_all_button.dart';

class CreateColorPage extends StatefulWidget {

  final String initHexStr;
  final String name;

  @override
  _CreateColorPageState createState() => _CreateColorPageState();

  CreateColorPage(
      {Key key,
        this.initHexStr = "FFFFFF",
        this.name = 'Maximum White',
      }
    ): super(key: key);
}

class _CreateColorPageState extends State<CreateColorPage> {

  double _red = 255;
  double _green = 255;
  double _blue = 255;
  String hexCode;

  TextStyle numTextStyle = TextStyle(
    fontFamily: "RobotoMono",
    fontSize: 20
  );

  final nameFieldController = TextEditingController(text: '');
  final hexFieldController = TextEditingController(text: '');
  final _hexFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    hexCode = widget.initHexStr;
    updateSlidersAndHexCode(widget.initHexStr);
    nameFieldController.text = widget.name;
  }

  // Learning note: override to dispose of TextEditingController as well
  @override
  void dispose() {
    super.dispose();
    nameFieldController.dispose();
    hexFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new color'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: <Widget>[
          Container(
            height: 150,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(_red.round(), _green.round(), _blue.round(), 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Form(
              key: _hexFormKey,
              child: TextFormField(
                decoration: InputDecoration(
                  prefixText: '#',
                ),
                controller: hexFieldController,
                maxLength: 6,
                maxLengthEnforced: true,
                onChanged: (inputString) {
                  if (_hexFormKey.currentState.validate()) {
                    updateSlidersAndHexCode(inputString);
                    setState(() {});
                  }
                },
                validator: (inputString) {
                  if (!isAHexCode(inputString)) {
                    return "Please enter a valid hex color";
                  }
                    return null;
                },
                textAlign: TextAlign.center,
                style: numTextStyle
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  color: Colors.red,
                ),
                Container(
                  width: 40,
                  child: Text(_red.round().toString(),
                      style: numTextStyle
                  ),
                ),
                Slider(
                  value: _red,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: "Red: " + _red.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _red = value;
                      updateHexCode();
                    });
                  },
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                color: Colors.green,
              ),
              Container(
                width: 40,
                child: Text(_green.round().toString(),
                    style: numTextStyle
                ),
              ),
              Slider(
                value: _green,
                min: 0,
                max: 255,
                divisions: 255,
                label: "Green: " + _green.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _green = value;
                    updateHexCode();
                  });
                },
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 20,
                width: 20,
                color: Colors.blue,
              ),
              Container(
                width: 40,
                child: Text(_blue.round().toString(),
                    style: numTextStyle
                ),
              ),
              Slider(
                value: _blue,
                min: 0,
                max: 255,
                divisions: 255,
                label: "Blue: " + _blue.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _blue = value;
                    updateHexCode();
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Text('Enter color name',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              )
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: TextField(
              controller: nameFieldController, // Learning note: important identifier
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Color name',
                hintText: 'Enter new color\'s name here',
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                color: Colors.blue,
                textColor: Colors.white,
                icon: Icon(Icons.add),
                label: Text('Create new color'),
                onPressed: () {
                  if (_hexFormKey.currentState.validate()) {
                    Navigator.pop(context, ({"confirmAction": ConfirmAction.CREATE, "hex": hexCode, "name": nameFieldController.text}));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateSlidersAndHexCode(String inputString) {
    _red = int.parse(inputString.substring(0,2), radix: 16).toDouble();
    _green = int.parse(inputString.substring(2,4), radix: 16).toDouble();
    _blue = int.parse(inputString.substring(4,6), radix: 16).toDouble();
    updateHexCode();
  }

  void updateHexCode() {
//    hexCode = _red.round().toRadixString(16) +
//        _green.round().toRadixString(16) +
//        _blue.round().toRadixString(16);
    hexCode = convertToTwoDigitHexStr(_red) +
        convertToTwoDigitHexStr(_green) +
        convertToTwoDigitHexStr(_blue);
    hexCode = hexCode.toUpperCase();
    hexFieldController.text = hexCode;
  }

  bool isAHexCode(String value) {
    String pattern = "^[A-Fa-f0-9]{6}\$";
    RegExp hexRegex = new RegExp(pattern);
    return hexRegex.hasMatch(value);
  }

  String convertToTwoDigitHexStr(double value) {
    String output = value.round().toRadixString(16);
    if (output.length < 2) {
      output = "0" + output;
    }
    return output;
  }
}
