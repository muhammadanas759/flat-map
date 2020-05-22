import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

  static var _textInputController = TextEditingController();

  CounterFormField({
    FormFieldSetter<int> onSaved,
    int initialValue,
    bool autoValidate = false
  }) : super(
      onSaved: onSaved,
      initialValue: initialValue,
      builder: (FormFieldState<int> state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Tooltip(
              message: "marker range in meters",
              child: new Text(
                "Range:",
                style: bodyText(),
              ),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (state.value > 1) {
                  state.didChange(state.value - 1);
                  _textInputController.text = state.value.toString();
                }
              },
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _textInputController..text = state.value.toString(),
                onSubmitted: (String input) {
                  state.didChange(int.parse(input));
                  _textInputController.text = state.value.toString();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // labelText: state.value.toString(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(7),
                ],
              ),
            ),
            Text(
              "m",
              style: bodyText(),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                state.didChange(state.value + 1);
                _textInputController.text = state.value.toString();
              },
            ),
          ],
        );
      }
  );
}

Widget BackupTile({
  String text, Icon icon, Function onLongPressMethod
}){
  return ListTile(
    title: Text(
      text,
      style: bodyText(),
    ),
    trailing: icon,
    onLongPress: onLongPressMethod,
  );
}


