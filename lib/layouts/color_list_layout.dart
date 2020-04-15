import 'dart:convert';

import "package:flutter/material.dart";
import 'package:wallpaper/default_values_unused.dart';
import 'package:wallpaper/default_values_json.dart';
import 'package:wallpaper/layouts/color_layout.dart';
import 'package:intl/intl.dart';
import 'package:wallpaper/services/color_object.dart';
import 'package:wallpaper/layouts/create_color_layout.dart';
import 'package:wallpaper/services/confirm_action.dart';

import 'package:path_provider/path_provider.dart';
import 'package:wallpaper/services/storage.dart';

class ColorListLayout extends StatefulWidget {

  List<ColorObject> currentColorList;
  Storage storage = new Storage();
  final GlobalKey<ScaffoldState> _homeScaffoldKey = new GlobalKey<ScaffoldState>();


  ColorListLayout({Key key, @required this.currentColorList}): super(key: key);

  @override
  _ColorListLayoutState createState() => _ColorListLayoutState();
}

class _ColorListLayoutState extends State<ColorListLayout> {

  @override
  void initState() {
    super.initState();

    widget.currentColorList = new List();
    readLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: widget._homeScaffoldKey,
        backgroundColor: Colors.grey[850],
          body: GridView.builder(
            itemCount: widget.currentColorList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return(ColorLayout(color: widget.currentColorList[index], parentDeleteAndUpdate: deleteAndUpdate, index: index)); // Learning note: according to StackOverflow
            },
          ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Create a new color',
          onPressed: () async {
            var returnData = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateColorLayout())
            );
            if (returnData is Map) {
              widget._homeScaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text('New color \'' + returnData['name'] + '\' has been created.' ),
                  backgroundColor: Colors.grey[600],
                  duration: const Duration(seconds: 2),
                )
              );
              widget.currentColorList.add(new ColorObject(returnData['hex'], returnData['name']));
              setState(() {});
              writeLocalStorage();


            } else if (returnData == ConfirmAction.RESET_ALL){
              widget._homeScaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text('All colours have been restored to default values.' ),
                  backgroundColor: Colors.grey[600],
                  duration: const Duration(seconds: 3)
                )
              );

              // Learning note: await to make sure that data has been written into currentColorList before writing
              await resetDefaultValues();
              writeLocalStorage();
              setState(() {});
            }

          },
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      ),
    );
  }

  void deleteAndUpdate(int index) {

    ColorObject tempHolder = widget.currentColorList[index];

    widget._homeScaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text('Color \'' + widget.currentColorList[index].name + '\' has been deleted.' ),
        backgroundColor: Colors.grey[600],
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            widget.currentColorList.insert(index, tempHolder);
            setState(() {});
          }
        ),
      )
    );
    widget.currentColorList.removeAt(index);
    setState(() {});
    writeLocalStorage();
  }

  void writeLocalStorage() {
    String jsonContent = jsonEncode(widget.currentColorList);
    widget.storage.writeData(jsonContent);
    print("Storage data written");
  }

  void readLocalStorage() {
    buildColorListFromJson(widget.storage.readData());
    debugPrint('Data read from local storage');
  }

  void resetDefaultValues() {
    widget.currentColorList = new List();
    buildColorListFromJson(widget.storage.retrieveDefaultValues());
  }

  void buildColorListFromJson(dynamic jsonResponse) async {
    dynamic jsonRaw = await jsonResponse;
    List jsonContent = jsonDecode(jsonRaw);

    jsonContent.forEach((element){
      ColorObject newObject =  ColorObject(element["hex"], element["name"]);
      print('item created');
      widget.currentColorList.add(newObject);
    });
    setState((){});
  }

  void showSnackbarDebug(String content) {
    widget._homeScaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(content),
        backgroundColor: Colors.grey[600],
        duration: const Duration(seconds: 4),
      )
    );
  }

}
