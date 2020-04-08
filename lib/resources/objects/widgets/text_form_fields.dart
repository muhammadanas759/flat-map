import 'package:flutter/material.dart';

import 'package:flatmapp/resources/objects/widgets/text_styles.dart';


InputDecoration textFieldStyle({
    String labelTextStr="", String hintTextStr=""}) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(12),
    labelText: labelTextStr,
    hintText:hintTextStr,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

RaisedButton textFieldButton({String text, Function onPressedMethod}){
  return RaisedButton(
    elevation: 0.0,
    color: Colors.green,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(15.0),
      side: BorderSide(color: Colors.grey),
    ),
    padding: EdgeInsets.all(20.0),
    onPressed: onPressedMethod,
    child: Text(
    text,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    ),
  );
}