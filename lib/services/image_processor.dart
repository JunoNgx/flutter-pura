import 'dart:async';
import 'dart:io' as Io;
import 'dart:ui';
import 'package:image/image.dart' as dartImage;
import 'package:wallpaper/models/color_object.dart';

class ImageProcessor {

  final String targetFolder = "/storage/emulated/0/Pictures/Pura/";

  void processDirectory() async {
    if (!(await Io.Directory(targetFolder).exists())) {
      Io.Directory(targetFolder).create(recursive: true);
      print('Directory does not exist. Folder created.');
    }
  }

  Future<String> getFinalPath(ColorObject _color) async {
    processDirectory();
    String finalPath = targetFolder + _color.name + ".png";
    return finalPath;
  }

  Future<String> processImage(ColorObject _color) async {
    dartImage.Image _image= new dartImage.Image(128, 128, channels: dartImage.Channels.rgba);
    print(_color.hexCodeStr);
    print(_color.getHexInt().toString());
    _image.fill(_color.getHexInt());

    String finalPath = await getFinalPath(_color);

    Io.File(finalPath).writeAsBytesSync(dartImage.encodePng(_image));
    return finalPath;
  }

}