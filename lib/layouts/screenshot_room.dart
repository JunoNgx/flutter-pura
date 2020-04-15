import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';

import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper/services/color_object.dart';
import 'dart:ui' as ui;

class ScreenshotRoom extends StatelessWidget {

  final ColorObject color;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScreenshotRoom({Key key, @required this.color}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: _scaffoldKey,
        child: Scaffold(
            backgroundColor: Color(color.getHexInt()),
            floatingActionButton: FloatingActionButton(
              onPressed:_takeScreenshot,
            )
        )
    );
  }

  void _takeScreenshot() async{
    RenderRepaintBoundary boundary = _scaffoldKey.currentContext.findRenderObject();

    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _takeScreenshot();
    }

    // Learning note: preparing image data
    ui.Image image = await boundary.toImage();

    // Learning note: convert image to necessary byteData
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // TODO figure out what this line does
    Uint8List byteData2 = byteData.buffer.asUint8List();

    //Learning note: preparing file name, including app name, color name, a timestamp, and the extension of PNG
    String fileName = 'Pura ' + color.name + ' ' + (DateFormat("yMd-Hms").format(DateTime.now()).toString() + '.png');

    //Learning note: check if target folder exists
    const String targetFolder = "/storage/emulated/0/Pictures/Pura/";

    //Learning note: recursive will create all necessary folders
    if (!(await Directory(targetFolder).exists())) {
      Directory(targetFolder).create(recursive: true);
      debugPrint('Directory does not exist. Folder created.');
    }

    //Learning note: everything comes down to writing the file
    final File file = File(targetFolder + fileName);
    file.writeAsBytes(byteData2);
    print('File saved: ' + targetFolder + fileName);

    Wallpaperplugin.setWallpaperWithCrop(localFile: targetFolder + fileName);
  }
}

