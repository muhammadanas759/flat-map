import 'package:flutter/material.dart';

import '../objects/widgets/side_bar_menu.dart';
import '../objects/widgets/bottom_navigation_bar.dart';
import '../objects/widgets/app_bar.dart';
import '../objects/widgets/text_styles.dart';


class ActionsRoute extends StatelessWidget {

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
                'Actions',
                style: header(),
              ),
              leading: Icon(Icons.access_alarm),
            ),
            ListTile(
              title: Text(
                'Action 1',
                style: bodyText(),
              ),
            ),
            ListTile(
              title: Text(
                'Action 2',
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
      floatingActionButton: navigationBarButton(context),

    );
  }
}
