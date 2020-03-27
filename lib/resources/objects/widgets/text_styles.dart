import 'package:flutter/material.dart';
import 'package:decoding_text_effect/decoding_text_effect.dart';


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
          child: DecodingTextEffect(
            text,
            refreshDuration: Duration(milliseconds: 30),
            decodeEffect: DecodeEffect.fromStart,
            textStyle: TextStyle(
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