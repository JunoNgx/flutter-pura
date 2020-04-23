import 'package:flutter/material.dart';

class CreateGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      color: Colors.teal,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 96
            ),
            Text(
              'Create your new color from RGB sliders or a hex code',
              textAlign: TextAlign.center,
            )
          ],
        ),
        onTap: () {}
      ),
    );
  }
}
