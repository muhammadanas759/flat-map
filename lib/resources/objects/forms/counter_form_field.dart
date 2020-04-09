import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flutter/material.dart';


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
