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

  final textEditController = TextEditingController(text: 'Summer blue');


  // Learning note: override to dispose of TextEditingController as well
  @override
  void dispose() {
    super.dispose();
    textEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Create a new color'),
        centerTitle: true,
        backgroundColor: Colors.grey[600],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('#' + hexCode,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              Container(
                width: 80,
                child: TextFormField(

                ),
              ),
            ],
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
                  label: _red.round().toString(),
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
                label: _green.round().toString(),
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
                label: _blue.round().toString(),
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
              controller: textEditController, // Learning note: important identifier
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Color name',
                hintText: 'Enter new color\'s name here',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                fillColor: Colors.white,
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
                  Navigator.pop(context, ({"hex": hexCode, "name": textEditController.text}));
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
    debugPrint(hexCode);
  }
}
