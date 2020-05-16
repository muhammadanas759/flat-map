import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';


AppBar appBar({String title = 'FlatMApp prototype'}){
  return new AppBar(
    title: Text(title),
    backgroundColor: Color(0xFF4CAF50),
//    actions: <Widget>[
//      new IconButton(
//        icon: new Icon(Icons.close),
//        onPressed: () =>
//            SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
//      ),
//    ],
  );
}
