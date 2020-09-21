import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              _formData['test_value'].toString(),
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
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(
                      'Erase the account',
                      style: bodyText(),
                    ),
                    leading: Icon(Icons.cloud_off),
                    onTap: (){
                      setState(() {
                        _submitForm();
                      });
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
                    trailing: Icon(Icons.keyboard_return),
                    onTap: (){
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
      bool connected = await netLoader.checkNetworkConnection();
      if(connected){
        // send request to the server
        http.Response _response = await netLoader.removeAccount();
        if(200 <= _response.statusCode && _response.statusCode < 300){
          // move back
          Navigator.of(context).pop();
          // show message
          Fluttertoast.showToast(
            msg: "Account erased successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        netLoader.showToast("Network connection is off");
      }
    }
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
