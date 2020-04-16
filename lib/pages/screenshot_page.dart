import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wallpaperplugin/wallpaperplugin.dart';
import 'package:wallpaper/models/color_object.dart';

class ScreenshotPage extends StatelessWidget {

  final ColorObject color;
  final GlobalKey<ScaffoldState> _boundaryKey = new GlobalKey<ScaffoldState>();

  ScreenshotPage({Key key, @required this.color}): super(key: key);

  @override
  // Learning note: immediately run the screenshot method after finished building
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      _takeScreenshot();
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF242424).withOpacity(0.2),
      ),
      body: RepaintBoundary(
          key: _boundaryKey,
          child: Scaffold(
              backgroundColor: Color(color.getHexInt()),
          )
      ),
    );
  }

  void _takeScreenshot() async{
    RenderRepaintBoundary boundary = _boundaryKey.currentContext.findRenderObject();

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
    await file.writeAsBytes(byteData2);
    debugPrint('File saved: ' + targetFolder + fileName);

    Wallpaperplugin.setWallpaperWithCrop(localFile: targetFolder + fileName);
  }
}

