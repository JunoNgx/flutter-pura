import 'dart:convert';
import "package:flutter/material.dart";

import 'package:wallpaper/models/color_object.dart';
import 'package:wallpaper/pages/create_color_page.dart';
import 'package:wallpaper/services/confirm_action.dart';
import 'package:wallpaper/services/storage.dart';
import 'package:wallpaper/widgets/color_grid.dart';
import 'package:wallpaper/widgets/extra_grid.dart';
import 'package:wallpaper/widgets/confirmation_dialog.dart';
import 'package:wallpaper/widgets/custom_about_dialog.dart';

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

    initColorList();
    readLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: widget._homeScaffoldKey,
        body: GridView.builder(
          itemCount: widget.currentColorList.length + 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            Widget _widget;
            if (index < widget.currentColorList.length) {
              _widget = ColorGrid(
                  color: widget.currentColorList[index],
                  parentDeleteAndUpdate: deleteAndUpdate,
                  parentCreateNewColor: createNewColor,
                  index: index
              );
            } else if (index == widget.currentColorList.length) {
              _widget = ExtraGrid(
                icon: Icons.add,
                label: 'Create a new color from RGB sliders or a hex code',
                color: Colors.teal,
                action: () async {
                  var returnData = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateColorPage())
                  );
                  if (returnData is Map) {
                    if (returnData["confirmAction"] == ConfirmAction.CREATE) {
                      createNewColor(
                          new ColorObject(returnData['hex'], returnData['name']));
                    }
                  }
                }
              );
            } else if (index == widget.currentColorList.length + 1) {
              _widget = ExtraGrid(
                  icon: Icons.restore,
                  label: 'Reset all colors to default values',
                  color: Colors.pinkAccent,
                  action: () async {
                    ConfirmAction confirm = await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) => ConfirmationDialog(
                          title: 'CONFIRM RESET ALL',
                          content: 'Are you sure you want to reset all colors? All user created data will be wiped.',
                          confirmAction: ConfirmAction.RESET_ALL,
                        )
                    );
                    if (confirm == ConfirmAction.RESET_ALL) {
                      print('RESET_ALL sent from Create Page');
                      resetDefaultValues();
                    }
                  },
              );
            } else if (index == widget.currentColorList.length + 2) {
              _widget = ExtraGrid(
                  icon: Icons.info,
                  label: 'Help and information about the app',
                  color: Colors.yellow[700],
                  action: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => CustomAboutDialog()
                        //TODO figure out how the default AboutDialog works
//                      builder: (context) => AboutDialog()
                    );
                  }
              );
            }
            return _widget;
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
    initColorList();
    // Learning note: wait for the new (old) data to be built before writing again
    // else this will cause a blank userdata at the next startup
    await buildColorListFromJson(widget.storage.retrieveDefaultValues());
    writeLocalStorage();
    showSnackbar('All colours have been restored to default values.');
  }

  void buildColorListFromJson(dynamic jsonResponse) async {
    //TODO figure out if this can be optimised
    dynamic jsonRaw = await jsonResponse;
    List jsonContent = jsonDecode(jsonRaw);

    jsonContent.forEach((element){
      ColorObject newObject = ColorObject(element["hex"], element["name"]);
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

  void initColorList() {
    if (widget.currentColorList == null) {
      widget.currentColorList = new List();
    } else {
      widget.currentColorList.removeRange(0, widget.currentColorList.length);
    }
  }

}
