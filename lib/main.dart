import 'package:flutter/material.dart';
import 'package:wallpaper/pages/color_list_page.dart';

void main() {
  runApp(MaterialApp(
    home: ColorListPage(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[600],
      accentColor: Colors.teal,
      scaffoldBackgroundColor: Colors.grey[800],
      fontFamily: 'RobotoCondensed',
    ),
  ));
}