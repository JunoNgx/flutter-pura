//import "package:flutter/material.dart";
//import "package:wallpaper/services/confirm_action.dart";
//
//class ResetAllConfirmationDialog extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return AlertDialog(
//      title: Text('CONFIRM RESET ALL'),
//      content: Text('Are you sure you want to reset all colors? All user created data will be wiped.'),
//      actions: <Widget>[
//        FlatButton(
//          child: Text('Confirm',
//            style: TextStyle(
//              color: Colors.pink,
//            ),
//          ),
//          onPressed: ((){
//            Navigator.of(context).pop(ConfirmAction.RESET_ALL);
//          }),
//        ),
//        FlatButton(
//          child: Text('Cancel'),
//          onPressed: ((){
//            Navigator.of(context).pop(ConfirmAction.CANCEL);
//          }),
//        )
//      ],
//    );
//  }
//}
