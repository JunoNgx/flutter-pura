import 'dart:async';
import 'dart:io' as Io;
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
    dartImage.Image _image= new dartImage.Image.rgb(128, 128);
    print(_color.hexCodeStr);
    print(_color.getHexInt().toString());
    // Learning note: from documentation, this appears to be in #AABBGGRR channel order
    // TODO find out how to use AARRGGBB channel instead
    int fixedColor = workaroundConvertToBgr(_color.hexCodeStr);
    _image.fill(fixedColor);

    String finalPath = await getFinalPath(_color);

    Io.File(finalPath).writeAsBytesSync(dartImage.encodePng(_image));
    return finalPath;
  }

  int workaroundConvertToBgr(String input) {
    String _red = input.substring(0, 2);
    String _green = input.substring(2, 4);
    String _blue = input.substring(4, 6);
    int output = int.parse("0xFF" + _blue + _green + _red);
    return output;
  }

}