import 'package:flutter/material.dart';
import 'package:wallpaper/services/confirm_action.dart';
import 'package:wallpaper/widgets/confirmation_dialog.dart';

class CreateColorPage extends StatefulWidget {
  @override
  _CreateColorPageState createState() => _CreateColorPageState();
}

class _CreateColorPageState extends State<CreateColorPage> {

  double _red = 255;
  double _green = 255;
  double _blue = 255;
  String hexCode = "FFFFFF";

  final nameFieldController = TextEditingController(text: 'Maximum White');
  final hexFieldController = TextEditingController(text: 'FFFFFF');
  final _hexFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
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
                controller: hexFieldController,
                maxLength: 6,
                maxLengthEnforced: true,
                onChanged: (inputString) {
                  if (_hexFormKey.currentState.validate()) {
                    _red = int.parse(inputString.substring(0,2), radix: 16).toDouble();
                    _green = int.parse(inputString.substring(2,4), radix: 16).toDouble();
                    _blue = int.parse(inputString.substring(4,6), radix: 16).toDouble();
                    updateHexCode();
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
            onPressed: () async {
              ConfirmAction confirm = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => ConfirmationDialog(
                  title: 'CONFIRM RESET ALL',
                  content: 'Are you sure you want to reset all colors? All user created data will be wiped.',
                  confirmAction: ConfirmAction.RESET_ALL,
                )
              );
              if (confirm == ConfirmAction.RESET_ALL) {
                Navigator.pop(context, ConfirmAction.RESET_ALL);
              }
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
