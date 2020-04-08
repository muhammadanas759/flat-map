import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flutter/material.dart';

import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';


class MarkerAddForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MarkerAddFormState();
  }
}

class _MarkerAddFormState extends State<MarkerAddForm> {

  final IconsLoader icons = IconsLoader();

  Widget _iconsListView(BuildContext context) {
    return ListView.builder(
      itemCount: icons.markerImageLocal.length,
      itemBuilder: (context, index) {
        String key = icons.markerImageLocal.keys.elementAt(index);
        return Card( //                           <-- Card widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(icons.markerImageLocal[key]),
            ),
            title: Text(key, style: bodyText()),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // do something
              print(key);
            },
          ),
        );
      },
    );
  }

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

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),

      // BODY FORM
      body: Form(
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

              _iconsListView(context),
            ],
          )
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
