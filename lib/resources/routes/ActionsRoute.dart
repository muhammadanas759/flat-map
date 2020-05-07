import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';


class ActionsRoute extends StatelessWidget {

  final Map<String, String> _actionsMap = {
    'mute': 'assets/actions/water.png',
    'buletooth': 'assets/icons/factory.png'
  };

  Widget _actionsListView(BuildContext context) {
    return ListView.builder(
      itemCount: _actionsMap.length,
      itemBuilder: (context, index) {
        String key = _actionsMap.keys.elementAt(index);
        return Card( //                           <-- Card widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(_actionsMap[key]),
            ),
            title: Text(
              key,
              style: bodyText()
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // add action to the selected marker id
              PrefService.setString('selected_action', key);
              // Navigate back
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:
      // BODY
      _actionsListView(context),
      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
