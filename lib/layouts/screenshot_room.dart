import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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

    // Learning note: preparing image data
    ui.Image image = await boundary.toImage();

    // Learning note: convert image to necessary byteData
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // TODO figure out what this line does
    Uint8List byteData2 = byteData.buffer.asUint8List();

    //Learning note: preparing file name, including app name, color name, a timestamp, and the extension of PNG
    String fileName = 'Pura ' + widget.color.name + ' ' + (DateFormat("yMd-Hms").format(DateTime.now()).toString() + '.png');

    //Learning note: check if target folder exists
//    const String pathToPictures = "/storage/emulated/0/Pictures/";
//    const String appFolderName = "Pura";
//    const String targetFolder = pathToPictures + appFolderName + "/";
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
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/colorStorage.json');
  }
}
