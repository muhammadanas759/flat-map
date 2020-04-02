import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flutter/material.dart';

import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
// import 'package:flatmapp/resources/objects/widgets/bottom_navigation_bar.dart';


class CommunityRoute extends StatefulWidget {
  @override
  _CommunityRouteState createState() => _CommunityRouteState();
}

class _CommunityRouteState extends State<CommunityRoute> {
  final IconsLoader icons = IconsLoader();

  Expanded queryResults(){
    // QUERY RESULTS
    return Expanded(child: new Card());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:
      // BODY
      new Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Community',
              style: header(),
            ),
            leading: Icon(Icons.language),
          ),

          ListTile(
            title: Text(
              'community data',
              style: bodyText(),
            ),
            onLongPress: (){

            },
          ),

          queryResults(),

          ListTile(
            title: Text(
              'FlatMapp Team @ 2020',
              style: footer(),
            ),
          ),
        ],
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),

      // NAVIGATION BAR
      // floatingActionButton: navigationBarButton(context),

    );
  }
}
