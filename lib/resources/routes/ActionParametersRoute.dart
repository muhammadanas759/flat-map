import 'package:flatmapp/resources/extensions.dart';
import 'package:flatmapp/resources/objects/loaders/actions_loader.dart';
import 'package:flatmapp/resources/objects/loaders/languages/languages_loader.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/models/flatmapp_action.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preferences/preferences.dart';

// ignore: must_be_immutable
class ActionParametersRoute extends StatefulWidget {
  // data loader
  MarkerLoader _markerLoader = MarkerLoader();

  ActionParametersRoute(this._markerLoader, {Key key}) : super(key: key);

  @override
  _ActionParametersRouteState createState() => _ActionParametersRouteState();
}

// Putting language dictionaries seams done

class _ActionParametersRouteState extends State<ActionParametersRoute> {
  ActionsLoader _actionsLoader = ActionsLoader();

  FlatMappAction _selected_action;

  // selected menu in navigator
  int _selectedIndex = 0;

  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};
  Map<String, dynamic> _defaultFormData = {
    'sound': {
      'param1': '0',
    },
    'change alarm volume': {
      'param1': '0',
    },
    'change ringtone volume': {
      'param1': '0',
    },
    'change multimedia volume': {
      'param1': '0',
    },
    'bluetooth': {'param1': 'true'},
    'wi-fi': {'param1': 'true'},
  };

  final focusParam1 = FocusNode();
  final focusParam2 = FocusNode();

  void _walidateDefaultValues() {
    if (_defaultFormData.containsKey(_selected_action.name)) {
      _defaultFormData[_selected_action.name].forEach((key, value) {
        if (_formData[key] == "") {
          _formData[key] = value;
        }
      });
    }
  }

  //----------------------- ACTION PARAMETERS WIDGETS --------------------------

  Widget _soundAlarmWidget() {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Slider(
          value: toDouble(_formData['param1'], 0),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          min: 0,
          max: 100,
          divisions: 100,
          label: _formData['param1'],
          onChanged: (double value) {
            setState(() {
              _formData['param1'] = value.round().toString();
            });
          },
        ),
      ]),
    );
  }

  Widget _soundRingtoneWidget() {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Slider(
          value: toDouble(_formData['param1'], 0),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          min: 0,
          max: 100,
          divisions: 100,
          label: _formData['param1'],
          onChanged: (double value) {
            setState(() {
              _formData['param1'] = value.round().toString();
            });
          },
        ),
      ]),
    );
  }

  Widget _soundMultimediaWidget() {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Slider(
          value: toDouble(_formData['param1'], 0),
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          min: 0,
          max: 100,
          divisions: 100,
          label: _formData['param1'],
          onChanged: (double value) {
            setState(() {
              _formData['param1'] = value.round().toString();
            });
          },
        ),
      ]),
    );
  }

  Widget _wifiWidget() {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        RadioListTile(
          title: Text(
            LanguagesLoader.of(context).translate("Turn wi-fi on"),
            style: bodyText(),
          ),
          value: true,
          groupValue: toBool(_formData['param1'], true),
          onChanged: (value) {
            setState(() {
              _formData['param1'] = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text(
            LanguagesLoader.of(context).translate("Turn wi-fi off"),
            style: bodyText(),
          ),
          value: false,
          groupValue: toBool(_formData['param1'], true),
          onChanged: (value) {
            setState(() {
              _formData['param1'] = value.toString();
            });
          },
        ),
      ]),
    );
  }

  Widget _bluetoothWidget() {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        RadioListTile(
          title: Text(
            LanguagesLoader.of(context).translate("Turn bluetooth on"),
            style: bodyText(),
          ),
          value: true,
          groupValue: toBool(_formData['param1'], true),
          onChanged: (value) {
            setState(() {
              _formData['param1'] = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text(
            LanguagesLoader.of(context).translate("Turn bluetooth off"),
            style: bodyText(),
          ),
          value: false,
          groupValue: toBool(_formData['param1'], true),
          onChanged: (value) {
            setState(() {
              _formData['param1'] = value.toString();
            });
          },
        ),
//
//            TextFormField(
//              style: bodyText(),
//              decoration: textFieldStyle(
//                  labelTextStr: "Bluetooth parameter 1"
//              ),
//              initialValue: _formData['param1'].toString(),
//              onSaved: (String value) {
//                _formData['param1'] = value;
//              },
//              textInputAction: TextInputAction.next,
//              onFieldSubmitted: (value) {
//                _formData['param1'] = value;
//                FocusScope.of(context).requestFocus(focusParam2);
//              },
//              focusNode: focusParam1,
//            ),
//            SizedBox(height: 20),
//            TextFormField(
//              style: bodyText(),
//              decoration: textFieldStyle(
//                  labelTextStr: "Bluetooth parameter 2"
//              ),
//              initialValue: _formData['param2'].toString(),
//              onSaved: (String value) {
//                _formData['param2'] = value;
//              },
//              textInputAction: TextInputAction.next,
//              onFieldSubmitted: (value) {
//                _formData['param2'] = value;
//                focusParam2.unfocus();
//              },
//              focusNode: focusParam2,
//            ),
      ]),
    );
  }

  Widget _notificationWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        TextFormField(
          style: bodyText(),
          decoration: textFieldStyle(
              labelTextStr:
                  LanguagesLoader.of(context).translate("Notification title")),
          initialValue: _formData['param1'].toString(),
          onSaved: (String value) {
            _formData['param1'] = value;
          },
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            _formData['param1'] = value;
            FocusScope.of(context).requestFocus(focusParam2);
          },
          focusNode: focusParam1,
        ),
        SizedBox(height: 20),
        TextFormField(
          style: bodyText(),
          decoration: textFieldStyle(
              labelTextStr: LanguagesLoader.of(context)
                  .translate("Notification description")),
          initialValue: _formData['param2'].toString(),
          onSaved: (String value) {
            _formData['param2'] = value;
          },
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            _formData['param2'] = value;
            focusParam2.unfocus();
          },
          focusNode: focusParam2,
        ),
      ]),
    );
  }

  Widget _noWidget(BuildContext context, String actionname) {
    return ListTile(
      title: Text(
          LanguagesLoader.of(context).translate(actionname) +
              " " +
              LanguagesLoader.of(context)
                  .translate("[action] has no parameters"),
          style: bodyText()),
      trailing: Icon(Icons.not_interested),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _actionSelectorWidget(BuildContext context, String selected_widget) {
    // TODO this section has to match completely with actions_loader.actionsMap!
    // TODO validation has to match with switch!
    _walidateDefaultValues();

    switch (selected_widget) {
      case "change alarm volume":
        return _soundAlarmWidget();
        break;
      case "change ringtone volume":
        return _soundRingtoneWidget();
        break;
      case "change multimedia volume":
        return _soundMultimediaWidget();
        break;
      case "bluetooth":
        return _bluetoothWidget();
        break;
      case "notification":
        return _notificationWidget(context);
        break;
      case "wi-fi":
        return _wifiWidget();
//      case "flight":
//        return _noWidget(context, "flight mode");
//        break;
      case "single sound":
        return _noWidget(context, "single sound");
        break;
      case "mute":
        return _noWidget(context, "mute");
        break;
      case "unmute":
        return _noWidget(context, "unmute");
        break;
      default:
        return ListTile(
            title: Text(
              LanguagesLoader.of(context)
                      .translate("Could not find widget for: ") +
                  '$selected_widget!',
              style: bodyText(),
            ),
            leading: Icon(Icons.error_outline));
    }
  }

  Widget _parametersColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
              LanguagesLoader.of(context).translate(_selected_action.name),
              style: header()),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage:
                AssetImage(_actionsLoader.actionsMap[_selected_action.icon]),
          ),
        ),
        _actionSelectorWidget(context, _selected_action.name),
      ],
    );
  }

  Future<void> _submitForm() async {
    // validate form
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        print("ok");
        print(_formData);

        // save data from form to action
        widget._markerLoader.setMarkerActionSingle(
            marker_id: PrefService.getString('selected_marker'),
            action_position: PrefService.getInt('selected_action'),
            action_parameters: _formData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _selected_action = widget._markerLoader.getMarkerActionSingle(
        marker_id: PrefService.getString('selected_marker'),
        action_position: PrefService.getInt('selected_action'));

    _formData = _selected_action.parameters;

    return Scaffold(
      appBar: appBar(
          title: LanguagesLoader.of(context).translate("Action parameters")),
//      appBar: appBar(title: 'Action parameters'),
      body:
          // BODY
          Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: _parametersColumn(context),
      ),
      // SIDE PANEL MENU
      drawer: sideBarMenu(context),

      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              title: Text(LanguagesLoader.of(context).translate("Accept")),
//            title: Text("Accept"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_return),
              title: Text(LanguagesLoader.of(context).translate("Return")),
//            title: Text('Return'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: (int index) {
            setState(() {
              switch (index) {
                case 0:
                  // save changes from form
                  _submitForm();
                  // return to previous screen
                  Navigator.of(context).pop();
                  // show message
                  Fluttertoast.showToast(
                    msg: LanguagesLoader.of(context)
                        .translate("Action parameters saved"),
//                  msg: "Action parameters saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  break;
                case 1:
                  Navigator.of(context).pop();
                  break;
              }
            });
          }),
    );
  }
}
