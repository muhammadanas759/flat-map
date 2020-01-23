import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../objects/widgets/side_bar_menu.dart';

class SettingsRoute extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlatMApp prototype'),
        backgroundColor: Color(0xFF4CAF50),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
        ],
      ),
      body:

      // BODY
      Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context)
    );
  }
}
