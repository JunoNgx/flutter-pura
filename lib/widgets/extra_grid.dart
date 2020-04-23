import 'package:flutter/material.dart';

class ExtraGrid extends StatelessWidget {

  final IconData icon;
  final String label;
  final Color color;
  final Function action;

  ExtraGrid(
    {Key key,
      @required this.icon,
      @required this.label,
      @required this.color,
      @required this.action
    }
  ): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      color: this.color,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              this.icon,
              size: 96
            ),
            Text(
              this.label,
              textAlign: TextAlign.center,
            )
          ],
        ),
        onTap: action
      ),
    );
  }
}
