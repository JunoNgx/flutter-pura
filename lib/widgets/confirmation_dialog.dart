import 'package:flutter/material.dart';

import 'package:wallpaper/services/confirm_action.dart';

class ConfirmationDialog extends StatelessWidget {

  final String title;
  final String content;
  final ConfirmAction confirmAction;

  ConfirmationDialog({@required this.title, @required this.content, @required this.confirmAction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      actions: <Widget>[
        FlatButton(
          child: Text('Confirm',
            style: TextStyle(
              color: Colors.pink,
            ),
          ),
          onPressed: ((){
            Navigator.of(context).pop(this.confirmAction);
          }),
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: ((){
            Navigator.of(context).pop(ConfirmAction.CANCEL);
          }),
        ),
      ],
    );
  }
}
