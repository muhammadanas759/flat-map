import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flutter/material.dart';

import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/bottom_navigation_bar.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';


class CommunityRoute extends StatefulWidget {
  @override
  _CommunityRouteState createState() => _CommunityRouteState();
}

class _CommunityRouteState extends State<CommunityRoute> {
  MarkerLoader markersLoader = MarkerLoader();
  final IconsLoader icons = IconsLoader();

  Expanded queryResults(){
    // QUERY RESULTS
    if(markersLoader.markersMap == null){
      return Expanded(child: new Card());
    } else {
      return new Expanded(
        child: new ListView.separated(
          itemCount:markersLoader.markersMap.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(
                    icons.iconsMapLocal[markersLoader.markersMap[index]['icon']]
                ),
              ),
              title:  SelectableText(
                  markersLoader.markersMap[index]['icon'],
                  showCursor: false,
                  toolbarOptions: ToolbarOptions(
                      copy: true,
                      selectAll: true,
                      cut: false,
                      paste: false
                  ),
                  style: bodyText()
              ),
              subtitle: SelectableText(
                'Position: ' +
                    markersLoader.markersMap[index]['position'][0].toString() + ', ' +
                    markersLoader.markersMap[index]['position'][1].toString(),
                showCursor: false,
                toolbarOptions: ToolbarOptions(
                    copy: true,
                    selectAll: true,
                    cut: false,
                    paste: false
                ),
                style: footer(),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      );
    }
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
              'test markers download',
              style: bodyText(),
            ),
            onLongPress: (){
              setState(() {
                markersLoader.internetTest();
              });
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
      floatingActionButton: navigationBarButton(context),

    );
  }
}
