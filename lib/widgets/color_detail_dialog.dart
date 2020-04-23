import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';

import 'package:wallpaper/models/color_object.dart';
import 'package:wallpaper/services/confirm_action.dart';
import 'package:wallpaper/widgets/confirmation_dialog.dart';
import 'package:wallpaper/services/image_processor.dart';
import 'package:wallpaper/pages/create_color_page.dart';

class ColorDetailDialog extends AlertDialog {

  final ColorObject color;
  final int index;
  final GlobalKey<ScaffoldState> _colorDetailScaffoldKey = new GlobalKey<ScaffoldState>();
  ImageProcessor imageProcessor = ImageProcessor();

  ColorDetailDialog({@required this.color, @required this.index});

  @override
  Widget build(BuildContext context) {
    // Learning note: Scaffold is top widget for the purpose of displaying snackbar fullscreen
        return AlertDialog(
          actions: <Widget>[
            new FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
          ],
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
              onPressed: () {
                requestPermissionAndSetWallpaper(context);
              }
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              color: Colors.blue[700],
              textColor: Colors.white,
              icon: Icon(Icons.content_copy),
              label: Text('Clone colour'),
              onPressed: () async {
                var returnData = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)
                    => CreateColorPage(
                        initHexStr: color.hexCodeStr,
                        name: color.name,
                        showResetAll: false
                    )
                  )
                );
                if (returnData["confirmAction"] == ConfirmAction.CREATE) {
                  Navigator.pop(context, returnData);
                }
              },
            )
          ],
        ),
      );
  }
//
//  void processImage() {
//    Image image = new
//  }

  void requestPermissionAndSetWallpaper(BuildContext context) async {
    // Learning note: this will prompt permission from user
    // Learning note: will do nothing if permission is already granted
    await Permission.storage.request();
    bool isPermissionGranted = await Permission.storage.isGranted;
    print('Permission status: ' + isPermissionGranted.toString());
    String filePath = await imageProcessor.processImage(color, isPermissionGranted);
    setWallpaper(filePath);
  }

  void setWallpaper(String filePath) {
    Wallpaperplugin.setWallpaperWithCrop(localFile: filePath);
  }
}