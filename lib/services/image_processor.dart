import 'dart:async';
import 'dart:io' as Io;
import 'package:image/image.dart' as dartImage;
import 'package:wallpaper/models/color_object.dart';
import 'package:path_provider/path_provider.dart';

class ImageProcessor {

  final String externalTargetFolder = "/storage/emulated/0/Pictures/Pura/";

  void processDirectory(Io.Directory _directory) async {
    if (!(await _directory.exists())) {
      Io.Directory(_directory.path).create(recursive: true);
      print('Directory does not exist. Folder created.');
    } else {
      print('Directory pre-existed. No new directory created');
    }
  }

  Future<String> getFinalPath(ColorObject _color, bool _useExternalStorage) async {

    String targetFolder;

    if (_useExternalStorage) {
      targetFolder = externalTargetFolder; // files will be saved to Pictures/
      print('Permission granted, using external storage.');
    } else {
//      Io.Directory _internalDirectory = await getApplicationDocumentsDirectory();
      Io.Directory _internalDirectory = await getExternalStorageDirectory();
      targetFolder = _internalDirectory.path + "\/";
      print('Permission denied, using internal temporary storage.');
    }

    processDirectory(Io.Directory(targetFolder));
    String finalPath = targetFolder + _color.name + ".png";
    return finalPath;
  }

  int workaroundConvertToBgr(String input) {
    String _red = input.substring(0, 2);
    String _green = input.substring(2, 4);
    String _blue = input.substring(4, 6);
    int output = int.parse("0xFF" + _blue + _green + _red);
    return output;
  }

  Future<String> processImage(ColorObject _color, bool _useExternalStorage) async {
    dartImage.Image _image= new dartImage.Image.rgb(128, 128);
    // Learning note: from the documentation, this appears to be in #AABBGGRR channel order
    // TODO find out how to use AARRGGBB channel instead
    int fixedColor = workaroundConvertToBgr(_color.hexCodeStr);
    _image.fill(fixedColor);

    String finalPath = await getFinalPath(_color, _useExternalStorage);

    Io.File(finalPath).writeAsBytesSync(dartImage.encodePng(_image));
    print('Image saved to: ' + finalPath);
    return finalPath;
  }

}