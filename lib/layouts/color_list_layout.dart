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
//  ColorListLayout({this.currentColorList});

  @override
  _ColorListLayoutState createState() => _ColorListLayoutState();
}

class _ColorListLayoutState extends State<ColorListLayout> {

  @override
  void initState() {
    super.initState();
//    print(DateTime.now().toString());
//    print(DateFormat("yMd-Hms-").format(DateTime.now()));

    widget.currentColorList = new List();
    readLocalStorage();
//    resetDefaultValues();

//    buildColorListFromJson(widget.storage.retrieveDefaultValues());

    //For debug, do not delete
//    var jsonFileContent = "[{\"hex\":\"902E43\",\"name\":\"Dark Wine Red\",\"index\":0},{\"hex\":\"40826D\",\"name\":\"Viridian\",\"index\":1},{\"hex\":\"C8E6C9\",\"name\":\"Eraser\",\"index\":2},{\"hex\":\"FFCCC1\",\"name\":\"Salmon\",\"index\":3},{\"hex\":\"0080B0\",\"name\":\"Triumph Adler blue\",\"index\":4},{\"hex\":\"F1DDCF\",\"name\":\"Champagne pink\",\"index\":5},{\"hex\":\"E7CD8A\",\"name\":\"Light yellow\",\"index\":6},{\"hex\":\"FEF8EA\",\"name\":\"Light cream\",\"index\":7}]";
//
//
//    var jsonContent = jsonDecode(jsonFileContent);
//
//    jsonContent.forEach((element){
//      ColorObject newObject =  ColorObject(element["hex"], element["name"]);
//      widget.currentColorList.add(newObject);
//    });
//
//    widget.currentColorList = List.from(defaultValues);
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
//              debugPrint('Reset all request recieved.');
//              debugPrint(widget.currentColorList.toString());

              widget._homeScaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: Text('All colours have been restored to default values.' ),
                  backgroundColor: Colors.grey[600],
                  duration: const Duration(seconds: 3)
                )
              );
              resetDefaultValues();
              setState(() {});
              writeLocalStorage();
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
    print("storage written");
  }

  void readLocalStorage() {
    buildColorListFromJson(widget.storage.readData());
    debugPrint('Data read from local storage');
//    debugPrint('Data read from local storage' + jsonDecode(widget.storage.readData().toString()));
//    showSnackbarDebug('data read from storage');
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
