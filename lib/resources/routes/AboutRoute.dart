import 'package:flutter/material.dart';


import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';


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
                style: header(),
              ),
              leading: Icon(Icons.info_outline),
            ),
            ListTile(
              title: Text(
                'FlatMapp is an engineering project, aiming at creation of '
                'geolocation manager, triggering user-defined actions in '
                'declared geographical position.',
                style: bodyText(),
              ),
            ),
            ListTile(
              title: Text(
                'FlatMapp is free to use and is not gathering any personal data '
                'without user consent. All data gathered from application, such '
                'as user settings, saved locations or custom triggers, is '
                'anonymized before gathering. ',
                style: bodyText(),
              ),
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
      // floatingActionButton: navigationBarButton(context),
    );
  }
}
