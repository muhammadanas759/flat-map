import 'package:flutter/material.dart';


FloatingActionButton navigationBarButton(context){
  return new FloatingActionButton(
    onPressed: () {Navigator.pop(context);},
    tooltip: 'Return',
    child: new Icon(Icons.keyboard_return),
    elevation: 4.0,
  );
}
