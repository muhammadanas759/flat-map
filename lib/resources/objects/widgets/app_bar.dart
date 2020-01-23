import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


AppBar appBar(){
  return new AppBar(
    title: Text('FlatMApp prototype'),
    backgroundColor: Color(0xFF4CAF50),
    actions: <Widget>[
      new IconButton(
        icon: new Icon(Icons.close),
        onPressed: () =>
            SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      ),
    ],
  );
}