import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:preferences/preference_service.dart';


class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRouteState createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {

  // selected menu in navigator
  int _selectedIndex = 1;

  // internet service
  NetLoader netLoader = NetLoader();

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'username': '',
    'password': '',
    'password_2': '',
  };
  final focusPassword = FocusNode();

  Widget _buildEmailField(context) {
    return TextFormField(
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Email",
          hintTextStr: "Your email goes here"
      ),
      validator: (String value) {
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Invalid email format';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['username'] = value;
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
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password can not be empty';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
      focusNode: focusPassword,
      onFieldSubmitted: (v) {
        // _submitForm();
        // TODO move focus to password confirmation
      },
    );
  }

  Widget _buildPasswordField2() {
    return TextFormField(
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Confirm password",
          hintTextStr: "Your password goes here"
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password can not be empty';
        } else if(value != _formData['password']){
          return 'Passwords do not match';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['password_2'] = value;
      },
      onFieldSubmitted: (v) {
        _submitForm();
      },
    );
  }

  Future<void> _submitForm() async {
    // validate form
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // send credentials to server and get the response
      // TODO register endpoint
      http.Response _response = await netLoader.register(_formData);
      // TODO analyse response

      // show message
      Fluttertoast.showToast(
        msg: "Registered account",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Widget _registerForm(){
    // TODO REGISTER!
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("FORM IN DEVELOPMENT", style: header(),), // TODO remove
          SizedBox(height: 20),
          _buildEmailField(context),
          SizedBox(height: 20),
          _buildPasswordField(),
          SizedBox(height: 20),
          _buildPasswordField2(),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),

      // BODY FORM
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:  _registerForm()
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),

      bottomNavigationBar:
      PrefService.getString('token') != '' ?
      SizedBox.shrink() :
      BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            title: Text('Log in'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue),
            title: Text('Register'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_off),
            title: Text('Use as guest'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (int index) {
          switch(index){
            case 0:
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/login');
              break;
            case 1:
              _submitForm();
              break;
            case 2:
              // return to previous screen as guest
              Navigator.of(context).pop();
              break;
          }
        }
      ),
    );
  }
}
