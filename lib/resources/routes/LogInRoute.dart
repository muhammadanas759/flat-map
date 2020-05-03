import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';

import 'package:flutter/material.dart';
import 'dart:convert';


class LogInRoute extends StatefulWidget {
  @override
  _LogInRouteState createState() => _LogInRouteState();
}

class _LogInRouteState extends State<LogInRoute> {
  String _serverURL = "http://64.227.122.119:8000";
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
  };
  final focusPassword = FocusNode();

  Widget _buildEmailField(context) {
    return TextFormField(
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Email",
          hintTextStr: "Your email goes here"
      ),
      // ignore: missing_return
      validator: (String value) {
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Invalid email format';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusPassword);
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Password",
          hintTextStr: "Your password goes here"
      ),
      obscureText: false,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password can not be empty';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
      focusNode: focusPassword,
      onFieldSubmitted: (v) {
        _submitForm();
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      http.Response _response;
      _response = await http.post(
          _serverURL + "/api/account/login/",
          headers: {"Content-type": "application/json"},
          body: json.encode(_formData)
      );
      print(_response);
    }
  }

  Widget _logInForm(){
    return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            _buildEmailField(context),
            SizedBox(height: 20),
            _buildPasswordField(),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                textFieldButton(text: "Log in", onPressedMethod: _submitForm),
                SizedBox(width: 20),
                textFieldButton(text: "Sign up", onPressedMethod: _submitForm),
                SizedBox(width: 20),
                textFieldButton(text: "Use as guest", onPressedMethod: _submitForm),
              ],
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),

      // BODY FORM
      body: _logInForm(),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
