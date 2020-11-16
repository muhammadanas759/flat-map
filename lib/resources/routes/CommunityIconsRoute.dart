import 'package:flatmapp/resources/objects/loaders/languages/languages_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flatmapp/resources/objects/loaders/icons_loader.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';


// ignore: must_be_immutable
class CommunityIconsRoute extends StatefulWidget {
  @override
  _CommunityIconsRouteState createState() => _CommunityIconsRouteState();
}

class _CommunityIconsRouteState extends State<CommunityIconsRoute> {

  final IconsLoader icons = IconsLoader();

  Widget _iconCard(context, key){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 60.0,
        // icon change button
        child: Container(
            decoration: buttonFieldStyle(),
            child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: FlatButton(
                  onPressed: (){
                    setState(() {
                      // set selected marker id for map screen
                      PrefService.setString('community_icon', key);
                      // Navigate back
                      Navigator.pop(context);
                    });
                  },
                  padding: EdgeInsets.all(0.0),
                  child: Image.asset(
                    icons.markerImageLocal[key]
                  ),
                )
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: LanguagesLoader.of(context).translate("Choose icon for community")),
      body:
      // BODY
      GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4
        ),
        itemCount: icons.markerImageLocal.length,
        itemBuilder: (context, index) {
          return _iconCard(
            context,
            icons.markerImageLocal.keys.elementAt(index)
          );
        },
      ),
      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
