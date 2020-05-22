import 'dart:math';

import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';


class EraseAccountRoute extends StatefulWidget {

  @override
  _EraseAccountRouteState createState() => _EraseAccountRouteState();
}

class _EraseAccountRouteState extends State<EraseAccountRoute> {

  // internet service
  NetLoader netLoader = NetLoader();

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'test_value': '',
    'test_value_user': '',
  };

  String _randomCode() {
    var rng = new Random();
    return (rng.nextInt(900000) + 100000).toString();
  }

  Widget _eraseAccountForm(){
    _formData['test_value'] = _randomCode();
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              _formData['test_value'],
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: header(),
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: bodyText(),
              decoration: textFieldStyle(
                labelTextStr: "Please rewrite code above",
              ),
              validator: (String value) {
                if (value != _formData['test_value']) {
                  return 'Security codes do not match';
                }
                return null;
              },
              onSaved: (String value) {
                _formData['test_value_user'] = value;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                textFieldButton(text: "Erase the account", onPressedMethod: _submitForm),
                SizedBox(width: 20),
                textFieldButton(text: "Don't do it",
                  onPressedMethod: (){
                    Navigator.of(context).pop();
                  }
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
      //_formKey.currentState.save();

      print("account erased successfully");

      // TODO send new password to server and get the response
      // http.Response _response = await netLoader.changePassword(_formData);

      // move back
      Navigator.of(context).pop();

      // show message
      Fluttertoast.showToast(
          msg: "Account erased successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
      );
    }
//    else {
//      setState(() {
//        _formData['test_value'] = _randomCode();
//        _formData['test_value_user'] = "";
//      });
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Account removal'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  _eraseAccountForm(),
      ),
      drawer: sideBarMenu(context),
    );
  }
}
