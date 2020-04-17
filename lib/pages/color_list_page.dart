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
              return(ColorGrid(
                  color: widget.currentColorList[index],
                  parentDeleteAndUpdate: deleteAndUpdate,
                  parentCreateNewColor: createNewColor,
//                  parentResetAll: resetDefaultValues,
                  index: index
                )
              );
            },
          ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Create a new color',
          onPressed: () async {
            var returnData = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateColorPage(showResetAll: true,))
            );
            if (returnData is Map) {
              if (returnData["confirmAction"] == ConfirmAction.CREATE) {
                createNewColor(
                    new ColorObject(returnData['hex'], returnData['name']));
              }
            } else if (returnData == ConfirmAction.RESET_ALL) {
              print('Receiving RESET ALL from list page');
              // Learning note: await to make sure that data has been written into currentColorList before writing
              await resetDefaultValues();
            }
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
    writeLocalStorage();
    setState(() {});
  }

  void createNewColor(ColorObject color) {
    widget.currentColorList.add(color);
    showSnackbar('New color \'' + color.name + '\' has been created.');
    writeLocalStorage();
    setState(() {});
  }

  void writeLocalStorage() {
    widget.storage.writeData(jsonEncode(widget.currentColorList));
  }

  void readLocalStorage() {
    buildColorListFromJson(widget.storage.readData());
  }

  void resetDefaultValues() async {
    widget.currentColorList = new List();
    // Learning note: wait for the new (old) data to be built before writing again
    await buildColorListFromJson(widget.storage.retrieveDefaultValues());
    writeLocalStorage();
    showSnackbar('All colours have been restored to default values.');
  }

  void buildColorListFromJson(dynamic jsonResponse) async {
    //TODO figure out if this can be optimised
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
        backgroundColor: Colors.grey[400],
        duration: const Duration(seconds: 3),
      )
    );
  }

}
