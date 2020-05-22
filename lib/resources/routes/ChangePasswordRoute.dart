import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;


class ChangePasswordRoute extends StatefulWidget {

  @override
  _ChangePasswordRouteState createState() => _ChangePasswordRouteState();
}

class _ChangePasswordRouteState extends State<ChangePasswordRoute> {

  // internet service
  NetLoader netLoader = NetLoader();

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'password_old': '',
    'password_new_1': '',
    'password_new_2': '',
  };
  final focusPasswordOld = FocusNode();
  final focusPasswordNew1= FocusNode();
  final focusPasswordNew2 = FocusNode();

  Widget _buildPasswordField(context,
      {String label, String hint, String form_var, FocusNode focus_current, FocusNode focus_next}) {
    return TextFormField(
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: label,
          hintTextStr: hint,
      ),
      obscureText: true,
      validator: (String value) {
        if (form_var == "password_new_2" && value != _formData['password_new_1']) {
          return 'Passwords do not match';
        }
        return null;
      },
      onSaved: (String value) {
        _formData[form_var] = value;
      },
      textInputAction: TextInputAction.next,
      focusNode: focus_current,
      onFieldSubmitted: (v) {
        if(focus_next != null){
          FocusScope.of(context).requestFocus(focus_next);
        } else {
          _submitForm();
        }
      },
    );
  }

  Widget _changePasswordForm(){
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            _buildPasswordField(context,
                label: "Old password",
                hint: "Please provide your old password",
                form_var: "password_old",
                focus_current: focusPasswordOld,
                focus_next: focusPasswordNew1
            ),
            SizedBox(height: 20),
            _buildPasswordField(context,
                label: "New password",
                hint: "Please provide your new password",
                form_var: "password_new_1",
                focus_current: focusPasswordNew1,
                focus_next: focusPasswordNew2
            ),
            SizedBox(height: 20),
            _buildPasswordField(context,
                label: "Repeat new password",
                hint: "Please repeat your new password",
                form_var: "password_new_2",
                focus_current: focusPasswordNew2,
                focus_next: null
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(
                      'Change password',
                      style: bodyText(),
                    ),
                    leading: Icon(Icons.check),
                    onLongPress: (){
                      _submitForm();
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ListTile(
                    title: Text(
                      'Don\'t do it',
                      style: bodyText(),
                      textAlign: TextAlign.right,
                    ),
                    trailing: Icon(Icons.close),
                    onLongPress: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  Future<void> _submitForm() async {
    // validate form
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // TODO send new password to server and get the response
      // http.Response _response = await netLoader.changePassword(_formData);

      // move back
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Change password'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  _changePasswordForm(),
      ),
      drawer: sideBarMenu(context),
    );
  }
}
