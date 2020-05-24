import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preferences/preferences.dart';


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
              " m",
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
    onTap: onLongPressMethod,
  );
}

Widget addActionCard({String tooltip, Function onPressedMethod}){
  Color _color = (PrefService.get('ui_theme') == 'dark') ? Colors.white : Colors.black;
  return Container( //                           <-- Card widget
    child: Opacity(
      opacity: 0.2,
      child: IconButton(
        icon: Icon(Icons.add_circle_outline, size: 40,),
        color: _color,
        tooltip: tooltip,
        onPressed: onPressedMethod
      ),
    ),
    alignment: Alignment(0.0, 0.0),
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

Widget closeFormButton({Function onPressedMethod}){
  Color _color = (PrefService.get('ui_theme') == 'dark') ? Colors.white : Colors.black;
  return Container(
    child: Opacity(
      opacity: 0.2,
      child: IconButton(
        icon: Icon(Icons.keyboard_arrow_down, size: 40),
        color: _color,
        tooltip: 'Close form',
        onPressed: onPressedMethod,
      ),
    ),
    alignment: Alignment(0.0, 0.0),
  );
}

Future<void> raiseAlertDialogRemoveMarker(BuildContext context, MarkerLoader markerLoader, var id) async {

  var _marker = markerLoader.getMarkerDescription(id: id);

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          title: Text("Remove marker?"),
          content: Text(
              "You are about to remove marker\n"
                  "${_marker['title']}\n"
                  "${_marker['description']}."
          ),
          actions: [
            // set up the buttons
            FlatButton(
              child: Text("no nO NO"),
              onPressed:  () {
                // dismiss alert
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("HELL YEAH"),
              onPressed:  () {
                // remove marker
                markerLoader.removeMarker(id: id);
                // save markers state to file
                markerLoader.saveMarkers();
                // dismiss alert
                Navigator.of(context).pop();
              },
            ),
          ]
      );
    },
  );
}
