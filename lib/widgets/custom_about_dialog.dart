import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAboutDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Center(child: Text('About')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
             image: AssetImage('assets/Pura.png'),
             width: 96,
             height: 96,
           ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subhead,
              children: <TextSpan>[
                TextSpan(text: 'Pura', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                TextSpan(text: ' is an open-source app powered by '),
                TextSpan(
                  text: 'Google Flutter',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () { launch('https://flutter.dev/');
                    },
                ),
                TextSpan(text: ' and created by Juno Nguyen. '
                  'The app is the result of an attempt to dive in app developement '
                  'and self-sourcing of a quality app that could not be found.'),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'The app relies on external storage for wallpaper setting, '
                  'which requires user\'s permission. '
                  'This also results in a small image written to your gallery, '
                  'which subsequently can be re-used unlimitedly to set your wallpaper without the app. '
                ),
                TextSpan(text: '\n\n'),
                TextSpan(text: 'View the '),
                TextSpan(
                  text: 'source codes on GitHub.',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () { launch('https://github.com/JunoNgx/flutter-pura');
                    },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: ((){
            Navigator.of(context).pop();
          }),
        ),
      ],
    );
  }
}
