import 'package:flutter/material.dart';
import 'package:wallpaper/services/confirm_action.dart';
import 'package:wallpaper/widgets/confirmation_dialog.dart';


class ResetAllButton extends StatelessWidget {

  final bool visible;

  ResetAllButton(this.visible);

  @override
  Widget build(BuildContext context) {
    return visible == true
      ? RaisedButton.icon(
        color: Colors.pinkAccent,
        textColor: Colors.white,
        icon: Icon(Icons.restore),
        label: Text('RESET ALL COLOURS TO DEFAULT'),
        onPressed: () async {
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
            Navigator.pop(context, ConfirmAction.RESET_ALL);
          }
        },
      )
      :Container();
  }
}
