import 'package:flutter/material.dart';
import 'package:wallpaper/services/color_object.dart';
import 'package:wallpaper/services/confirm_action.dart';

class CreateColorLayout extends StatefulWidget {
  @override
  _CreateColorLayoutState createState() => _CreateColorLayoutState();
}

class _CreateColorLayoutState extends State<CreateColorLayout> {

  double _red = 255;
  double _green = 255;
  double _blue = 255;
  String hexCode = "FFFFFF";

  final nameFieldController = TextEditingController(text: 'Bright White');
  final hexFieldController = TextEditingController(text: 'FFFFFF');
  final _hexFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

//    debugPrint(isAHexCode('DSFDSFD').toString());
//    debugPrint(hexCodeValidator('1111FF11').toString());
//    debugPrint(hexCodeValidator('1111FF').toString());
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
//      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Create a new color'),
        centerTitle: true,
//        backgroundColor: Colors.grey[600],
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
                controller: hexFieldController,
                maxLength: 6,
                maxLengthEnforced: true,
                onChanged: (inputString) {
                  debugPrint("changed");
                  if (_hexFormKey.currentState.validate()) {
                    _red = int.parse(inputString.substring(0,2), radix: 16).toDouble();
                    _green = int.parse(inputString.substring(2,4), radix: 16).toDouble();
                    _blue = int.parse(inputString.substring(4,6), radix: 16).toDouble();
                    updateHexCode();
                    setState(() {});
                  }
                },
                validator: (inputString) {
                  //TODO figure out why validator isn't running
                  debugPrint('Validating');
                  if (!isAHexCode(inputString)) {
                    debugPrint('VAlidtor returned invalid');
                    return "Please enter a valid hex color";
                  }
                    debugPrint('VAlidtor returned null');
                    return null;
                },
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "RobotoMono",
                  fontSize: 20,
                ),
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
//                labelStyle: TextStyle(
//                  color: Colors.white,
//                ),
//                fillColor: Colors.white,
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
                    Navigator.pop(context, ({"hex": hexCode, "name": nameFieldController.text}));
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 60),
          RaisedButton.icon(
            color: Colors.pinkAccent,
            textColor: Colors.white,
            icon: Icon(Icons.restore),
            label: Text('RESET ALL COLOURS TO DEFAULT'),
            onPressed: () {
              Navigator.pop(context, ConfirmAction.RESET_ALL);
            },
          ),
        ],
      ),
    );
  }

  void updateHexCode() {
    hexCode = _red.round().toRadixString(16) +
        _green.round().toRadixString(16) +
        _blue.round().toRadixString(16);
    hexCode = hexCode.toUpperCase();
    hexFieldController.text = hexCode;
  }

  bool isAHexCode(String value) {
    String pattern = "^[A-Fa-f0-9]{6}\$";
    RegExp hexRegex = new RegExp(pattern);
    return hexRegex.hasMatch(value);
  }
}
