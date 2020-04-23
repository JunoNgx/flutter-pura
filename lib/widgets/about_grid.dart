import 'package:flutter/material.dart';

class AboutGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      color: Colors.yellow[700],
      child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                  Icons.info,
                  size: 96
              ),
              Text(
                'Help and information about the app',
                textAlign: TextAlign.center,
              )
            ],
          ),
          onTap: () {}
      ),
    );
  }
}
