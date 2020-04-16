import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Storage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/colorStorage.json');
  }

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

  Future<String> retrieveDefaultValues() async {
    return await rootBundle.loadString("assets/default_values.json");
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

}