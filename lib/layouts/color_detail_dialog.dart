import 'package:flutter/material.dart';
import 'package:wallpaper/services/color_object.dart';
import 'package:wallpaper/layouts/screenshot_room.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper/services/confirm_action.dart';

class ColorDetailDialog extends AlertDialog {

  final ColorObject color;
  final int index;
  final GlobalKey<ScaffoldState> _colorDetailScaffoldKey = new GlobalKey<ScaffoldState>();

  ColorDetailDialog({@required this.color, @required this.index});

  @override
  Widget build(BuildContext context) {
    // Learning note: Scaffold is top widget for the purpose of displaying snackbar fullscreen
        return Scaffold(
        key: _colorDetailScaffoldKey, // some kind of identifier for this particular scaffold, which will be used to control snackbar
        backgroundColor: Colors.transparent, // scaffold is actually fullscreen, but background is transparent
        body: AlertDialog(
//        backgroundColor: Colors.grey[850],
//        contentTextStyle: TextStyle(
//        color: Colors.white,
//            fontWeight: FontWeight.w400
//        ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton.icon(
                color: Colors.pink,
                textColor: Colors.white,
                icon: Icon(Icons.delete_forever),
                label: Text('Permanently delete'),
                onPressed: () {
                  Navigator.pop(context, {"confirmAction": ConfirmAction.DELETE, "indexToBeDeleted": index});
//                  debugPrint({"confirmAction": ConfirmAction.DELETE, "indexToBeDeleted": this.index}.toString());
                },
              ),
              Container(
                color: Color(color.getHexInt()),
                height: 150,
                margin: EdgeInsets.all(20),
              ),
              Text('#' + color.hexCodeStr,
                style: TextStyle(
                  fontFamily: "RobotoMono",
                  fontSize: 20,
                )
              ),
              SizedBox(height: 20),
              Text(color.name,
//                  style: TextStyle(
//                    fontSize: 20,
//                    fontWeight: FontWeight.bold
//                  )
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 20,
                    width: 20,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text((int.parse(color.hexCodeStr.substring(0,2), radix: 16)).toString()),
                  SizedBox(width: 30),
                  Container(
                    height: 20,
                    width: 20,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10),
                  Text((int.parse(color.hexCodeStr.substring(2,4), radix: 16)).toString()),
                  SizedBox(width: 30),
                  Container(
                    height: 20,
                    width: 20,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 10),
                  Text((int.parse(color.hexCodeStr.substring(4,6), radix: 16)).toString()),
                ],
              ),
              SizedBox(height: 20),
              RaisedButton.icon(
                color: Colors.teal,
                textColor: Colors.white,
                icon: Icon(Icons.wallpaper),
                label: Text('Set wallpaper'),
                onPressed: () async {
                  // Learning note: this will prompt permission from user
                  // Learning note: will do nothing if permission is already granted
                  var permissionIsGranted = await Permission.storage.request();
                  if (await Permission.storage.isGranted) {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => ScreenshotRoom(color: this.color)
                        )
                    );
                  } else {
                    debugPrint('Permission denied');
                    _colorDetailScaffoldKey.currentState.showSnackBar(new SnackBar(
                      content: Text('Permission not granted. Wallpaper setting is not available.'),
                      backgroundColor: Colors.grey[600],
                    ));
                  }
                },
              ),
            ],
          ),
        actions: <Widget>[
          new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
        ],
      ),
    );
  }
}