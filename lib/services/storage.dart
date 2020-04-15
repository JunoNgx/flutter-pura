import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:wallpaper/default_values_json.dart';
import 'package:wallpaper/services/color_object.dart';

class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/colorStorage.json');
  }

//  Future<dynamic> readData() async {
//    try {
//      final file = await _localFile;
//      dynamic content = await file.readAsString();
////      var decodedContent = jsonDecode(content);
////        return decodedContent.toString();
//      return content;
//    } catch (e) {
//      debugPrint('Local storage not available or retrieval failed. Using default values.');
//      return defaultValuesJson;
//    }
//  }

//  Future<dynamic> readData() async {
//    try {
//      final file = await _localFile;
//      dynamic content = await file.readAsString();
//      return content;
//    } catch (e) {
//      debugPrint('Local storage not available or retrieval failed. Using default values.');
//      return retrieveDefaultValues();
//    }
//  }

  Future<dynamic> readData() async {
    try {
      final file = await _localFile;
      dynamic content = await file.readAsString();
      return content;
    } catch (e) {
      debugPrint('Local storage not available or retrieval failed. Using default values.');
      return retrieveDefaultValues();
    }
  }

  Future<dynamic> retrieveDefaultValues() async {
    return defaultValuesJson;
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }


}