import 'package:flutter/material.dart';


TextStyle header(){
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}

TextStyle bodyText(){
  return TextStyle(
    fontSize: 16,
  );
}

TextStyle footer(){
  return TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 12,
  );
}

TextStyle sideBarMenuStyle(){
  return TextStyle(
    fontSize: 16,
  );
}

TextStyle sideBarMenuStyleGrey(){
  return TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );
}

Padding textInfo(String text){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.topCenter,
      child: Card(
        elevation: 2,
        color: Colors.grey.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}

InputDecoration textFieldStyle({
  String labelTextStr="",
  String hintTextStr="",
}) {
  return InputDecoration(
    contentPadding: EdgeInsets.all(12),
    labelText: labelTextStr,
    hintText:hintTextStr,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}


//Widget closeFormButton({Function onPressedMethod}){
//  Color _color = (PrefService.get('ui_theme') == 'dark') ? Colors.white : Colors.black;
//  return Material(
//      child: Ink(
//        decoration: BoxDecoration(
//          //border: Border.all(color: Colors.lightGreen, width: 5.0),
//          //color: Colors.green,
//          border: Border.all(
//              color: _color,
//              width: 5.0
//          ),
//          shape: BoxShape.circle,
//        ),
//        child: InkWell(
//          //This keeps the splash effect within the circle
//          borderRadius: BorderRadius.circular(1000.0),
//          child: Padding(
//            padding:EdgeInsets.all(1.0),
//            child: IconButton(
//              icon: Icon(Icons.keyboard_arrow_down, size: 40),
//              color: _color,
//              tooltip: 'Close form',
//              onPressed: onPressedMethod,
//            ),
//          ),
//        ),
//      )
//  );
//}
