import "package:flutter/material.dart";

import 'package:wallpaper/models/color_object.dart';
import "package:wallpaper/services/confirm_action.dart";
import "package:wallpaper/widgets/color_detail_dialog.dart";

class ColorGrid extends StatelessWidget {

  final ColorObject color;
  final int index;
  final ValueChanged<int> parentDeleteAndUpdate;
  final ValueChanged<ColorObject> parentCreateNewColor;

  ColorGrid(
      {Key key,
        @required this.color,
        @required this.index,
        @required this.parentDeleteAndUpdate,
        @required this.parentCreateNewColor,
      }
  ): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
//      decoration: BoxDecoration(
//        color: Color(this.color.getHexInt()),
//      ),
      color: Color(this.color.getHexInt()),
      child: InkWell(
        onTap: () async {
          final Map returnData = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => ColorDetailDialog(color: this.color, index: this.index)
          );
          if (returnData["confirmAction"] == ConfirmAction.DELETE) {
            this.parentDeleteAndUpdate(returnData["indexToBeDeleted"]);
            print('Color at position ' + returnData["indexToBeDeleted"].toString() + 'is to be deleted.');
          }
          if (returnData["confirmAction"] == ConfirmAction.CREATE) {
            this.parentCreateNewColor(new ColorObject(returnData['hex'], returnData['name']));
          }
        },
        child: Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black45,
              ),
              child: Text(
                  this.color.name,
                  style: TextStyle(
                    fontSize: 20,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
