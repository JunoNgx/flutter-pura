import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper/services/color_object.dart';
import 'dart:ui' as ui;

import 'package:image_picker_saver/image_picker_saver.dart';

class ScreenshotRoom extends StatefulWidget {

  final ColorObject color;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScreenshotRoom({Key key, @required this.color}): super(key: key);

  @override
  _ScreenshotRoomState createState() => _ScreenshotRoomState();
}

class _ScreenshotRoomState extends State<ScreenshotRoom> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: widget._scaffoldKey,
        child: Scaffold(
            backgroundColor: Color(widget.color.getHexInt()),
            floatingActionButton: FloatingActionButton(
              onPressed:_takeScreenshot,
            )
        )
    );
  }

  void _takeScreenshot() async{
    RenderRepaintBoundary boundary = widget._scaffoldKey.currentContext.findRenderObject();

    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _takeScreenshot();
    }

    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

//    print(pngBytes);

    var filePath = await ImagePickerSaver.saveFile(
        fileData: pngBytes,
        title: "Pura/" + DateFormat("yMd-Hms-").format(DateTime.now()),
    );
    //TODO change path to pictures/Pura/
  }
}
