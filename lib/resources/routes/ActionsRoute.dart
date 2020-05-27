import 'package:flatmapp/resources/objects/loaders/actions_loader.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/models/action.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';


class ActionsRoute extends StatefulWidget {
  // data loader
  MarkerLoader _markerLoader = MarkerLoader();
  ActionsRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _ActionsRouteState createState() => _ActionsRouteState();
}

class _ActionsRouteState extends State<ActionsRoute> {

  ActionsLoader _actionsLoader = ActionsLoader();

  Widget _actionsListView(BuildContext context) {
    return ListView.builder(
      itemCount: _actionsLoader.actionsMap.length,
      itemBuilder: (context, index) {
        String key = _actionsLoader.actionsMap.keys.elementAt(index);
        return Card( //                           <-- Card widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(_actionsLoader.actionsMap[key]),
            ),
            title: Text(
              key,
              style: bodyText()
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // add action to the selected marker id
              widget._markerLoader.addMarkerAction(
                id: PrefService.get('selected_marker'),
                action: FlatMappAction(key, key, -420, {"param": "none"})
              );
              // Navigate back
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Choose action'),
      body:
      // BODY
      _actionsListView(context),
      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
