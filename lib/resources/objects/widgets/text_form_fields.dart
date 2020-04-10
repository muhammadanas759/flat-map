import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flutter/material.dart';


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

RaisedButton textFieldButton({
  String text,
  Function onPressedMethod
}){
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

// https://medium.com/saugo360/creating-custom-form-fields-in-flutter-85a8f46c2f41
class CounterFormField extends FormField<int> {

  CounterFormField({
    FormFieldSetter<int> onSaved,
    int initialValue = 20,
    bool autoValidate = false
  }) : super(
      onSaved: onSaved,
      initialValue: initialValue,
      builder: (FormFieldState<int> state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Marker range:",
              style: bodyText(),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if(state.value > 1){
                  state.didChange(state.value - 1);
                }
              },
            ),
            Text(
              state.value.toString(),
              style: bodyText(),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                state.didChange(state.value + 1);
              },
            ),
          ],
        );
      }
  );
}
