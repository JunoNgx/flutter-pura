import 'dart:convert';

import "package:flutter/material.dart";
import 'package:wallpaper/widgets/color_grid.dart';
import 'package:wallpaper/models/color_object.dart';
import 'package:wallpaper/pages/create_color_page.dart';
import 'package:wallpaper/services/confirm_action.dart';
import 'package:wallpaper/services/storage.dart';

class ColorListPage extends StatefulWidget {

  List<ColorObject> currentColorList;
  Storage storage = new Storage();
  final GlobalKey<ScaffoldState> _homeScaffoldKey = new GlobalKey<ScaffoldState>();
  ColorListPage({Key key, @required this.currentColorList}): super(key: key);

  @override
  _ColorListPageState createState() => _ColorListPageState();
}

class _ColorListPageState extends State<ColorListPage> {

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
          body: GridView.builder(
            itemCount: widget.currentColorList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              return(ColorGrid(color: widget.currentColorList[index], parentDeleteAndUpdate: deleteAndUpdate, index: index)); // Learning note: according to StackOverflow
            },
          ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Create a new color',
          onPressed: () async {
            var returnData = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateColorPage())
            );
            if (returnData is Map) {
              widget.currentColorList.add(new ColorObject(returnData['hex'], returnData['name']));
              showSnackbar('New color \'' + returnData['name'] + '\' has been created.');

            } else if (returnData == ConfirmAction.RESET_ALL){
              // Learning note: await to make sure that data has been written into currentColorList before writing
              await resetDefaultValues();
              showSnackbar('All colours have been restored to default values.');
            }
            writeLocalStorage();
            setState(() {});
          },
        ),
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
  }

  void readLocalStorage() {
    buildColorListFromJson(widget.storage.readData());
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
      widget.currentColorList.add(newObject);
    });
    setState((){});
  }

  void showSnackbar(String content) {
    widget._homeScaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Text(content),
        backgroundColor: Colors.grey[600],
        duration: const Duration(seconds: 3),
      )
    );
  }

}
