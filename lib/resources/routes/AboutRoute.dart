import 'package:flutter/material.dart';

import '../objects/widgets/side_bar_menu.dart';
import '../objects/widgets/bottom_navigation_bar.dart';
import '../objects/widgets/app_bar.dart';


class AboutRoute extends StatelessWidget {

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
                'About',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                ),
              ),
              leading: Icon(Icons.info_outline),
            ),
            ListTile(
              title: Text(
                'FlatMapp is an engineering project, aiming at creation of '
                'geolocation manager, triggering user-defined actions in '
                'declared geographical position.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'FlatMapp is free to use and is not gathering any personal data '
                'without user consent. All data gathered from application, such '
                'as user settings, saved locations and custom triggers are '
                'anonymized before gathering. ',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'FlatMapp Team @ 2020',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                )
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
