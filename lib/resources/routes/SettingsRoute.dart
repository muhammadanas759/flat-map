import 'package:flutter/material.dart';

import '../objects/widgets/side_bar_menu.dart';
import '../objects/widgets/bottom_navigation_bar.dart';
import '../objects/widgets/app_bar.dart';
import '../objects/widgets/text_styles.dart';

class SettingsRoute extends StatefulWidget {
  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {

  bool _setting1 = false;
  bool _setting2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:

      // BODY
      ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text(
                'Settings',
                style: header(),
              ),
              leading: Icon(Icons.settings_applications),
            ),
            // https://api.flutter.dev/flutter/material/SwitchListTile-class.html
            SwitchListTile(
              title: Text(
                'Setting 1',
                style: bodyText(),
              ),
              value: _setting1,
              secondary: const Icon(Icons.lightbulb_outline),
              onChanged: (bool value) {
                setState(() {
                  _setting1 = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Setting 2',
                style: bodyText(),
              ),
              value: _setting2,
              secondary: const Icon(Icons.link),
              onChanged: (bool value) {
                setState(() {
                  _setting2 = value;
                });
              },
            ),
            ListTile(
              title: Text(
                  'FlatMapp Team @ 2020',
                  style: footer(),
              ),
            ),
          ],
        ).toList(),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),

      // NAVIGATION BAR
      floatingActionButton: navigationBarButton(context),
    );
  }
}

