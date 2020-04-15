import 'package:flutter/material.dart';
import 'package:wallpaper/layouts/color_list_layout.dart';
import 'package:wallpaper/default_values_unused.dart';
import 'package:wallpaper/layouts/create_color_layout.dart';
import 'package:wallpaper/services/storage.dart';

void main() {
  //TODO check local storage for colorList values, if not available then use default values

  runApp(MaterialApp(
    home: ColorListLayout(),
    theme: ThemeData(),
    darkTheme: ThemeData.dark(),
    routes: {
      '/main': (context) => ColorListLayout(),
      '/create': (context) => CreateColorLayout(),
    },
  ));
}