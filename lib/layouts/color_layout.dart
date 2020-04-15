import "package:flutter/material.dart";
import "package:wallpaper/services/color_object.dart";
import "package:wallpaper/services/confirm_action.dart";
import "package:wallpaper/layouts/color_detail_dialog.dart";
import "package:wallpaper/layouts/color_list_layout.dart";
import 'package:wallpaper/services/confirm_action.dart';

class ColorLayout extends StatelessWidget {

  final ColorObject color;
  final int index;
  final ValueChanged<int> parentDeleteAndUpdate;

  ColorLayout({Key key, @required this.color, @required this.parentDeleteAndUpdate, @required this.index}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(this.color.getHexInt()),
      ),
      child: InkWell(
        onTap: () async {
          final Map returnData = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => ColorDetailDialog(color: this.color, index: this.index)
          );
          if (returnData["confirmAction"] == ConfirmAction.DELETE) {
            this.parentDeleteAndUpdate(returnData["indexToBeDeleted"]);
            print('index of delete' + returnData["indexToBeDeleted"].toString());
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
                    fontSize: 16,
                    color: Colors.white,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<ConfirmAction> _showColorDetailDialog ({BuildContext context, Widget child}) async {
    final value = await showDialog(
      context: context,
      barrierDismissible: true,
        builder: (BuildContext context) => ColorDetailDialog(color: this.color)
    );
  }

//  Future<Map> _showColorDetailDialog(BuildContext context) async {
//    return showDialog<Map>(
//        context: context,
//        barrierDismissible: true,
//        builder: (BuildContext context) {
//          return ColorDetailDialog(color: this.color);
//        }
//    );
//  }

//  Widget build(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.all(8),
//      decoration: BoxDecoration(
//        color: Color(this.color.getHexInt()),
//      ),
//      child: Stack(
//        alignment: const Alignment(-1, 1),
//        children: [
//          FractionallySizedBox(
//            widthFactor: 1,
//            child: Container(
//              decoration: BoxDecoration(
//                color: Colors.black45,
//              ),
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  this.color.name,
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.white,
//                  )
//                ),
//              ),
//            ),
//          ),
//        ]
//      ),
//    );
//  }


//  Widget build(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.all(8),
//      decoration: BoxDecoration(
//        color: Color(this.color.getHexInt()),
//      ),
//      child: Align(
//        alignment: Alignment.bottomLeft,
//        child: FractionallySizedBox(
//          widthFactor: 1,
//          child: Container(
//            padding: const EdgeInsets.all(8.0),
//            decoration: BoxDecoration(
//              color: Colors.black45,
//            ),
//            child: Text(
//              this.color.name,
//              style: TextStyle(
//                fontSize: 16,
//                color: Colors.white,
//              )
//            ),
//          ),
//        ),
//      ),
//    );
//  }

}
