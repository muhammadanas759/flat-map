import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flutter/material.dart';

import '../objects/widgets/side_bar_menu.dart';
import '../objects/widgets/bottom_navigation_bar.dart';
import '../objects/widgets/app_bar.dart';
import '../objects/widgets/text_styles.dart';


class ActionsRoute extends StatelessWidget {

  final IconsLoader icons = IconsLoader();

  Widget _iconsListView(BuildContext context) {
    return ListView.builder(
      itemCount: icons.iconsMapLocal.length,
      itemBuilder: (context, index) {
        String key = icons.iconsMapLocal.keys.elementAt(index);
        return Card( //                           <-- Card widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(icons.iconsMapLocal[key]),
            ),
            title: Text(key, style: bodyText()),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // do something
              print(key);
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
      _iconsListView(context),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),

      // NAVIGATION BAR
      floatingActionButton: navigationBarButton(context),
    );
  }
}
