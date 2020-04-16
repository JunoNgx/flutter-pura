import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:wallpaper/models/color_object.dart';
import 'package:wallpaper/pages/screenshot_page.dart';
import 'package:wallpaper/services/confirm_action.dart';
import 'package:wallpaper/widgets/confirmation_dialog.dart';

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
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton.icon(
                color: Colors.pink,
                textColor: Colors.white,
                icon: Icon(Icons.delete_forever),
                label: Text('Permanently delete'),
                onPressed: () async {
                  ConfirmAction confirmAction = await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => ConfirmationDialog(
                      title: 'CONFIRM DELETE ITEM',
                      content: 'Are you sure you want to delete this color? Its data will be wiped.',
                      confirmAction: ConfirmAction.DELETE,
                    )
                  );
                  if (confirmAction == ConfirmAction.DELETE) {
                    Navigator.pop(context, {"confirmAction": ConfirmAction.DELETE, "indexToBeDeleted": index});
                  }
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
              Text(color.name),
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
                  await Permission.storage.request();
                  if (await Permission.storage.isGranted) {
                    print('Navigator pushing to screenshot page.');
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => ScreenshotPage(color: this.color)
                        )
                    );
                  } else {
                    print('Pura was denied permission to external storage.');
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