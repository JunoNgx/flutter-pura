import 'package:flutter/material.dart';

class ResetGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      color: Colors.pinkAccent,
      child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                  Icons.restore,
                  size: 96
              ),
              Text(
                'Reset all colors to default values',
                textAlign: TextAlign.center,
              )
            ],
          ),
          onTap: () {}
      ),
    );
  }
}
