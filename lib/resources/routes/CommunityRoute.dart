import 'dart:io';

import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';


class CommunityRoute extends StatefulWidget {

  MarkerLoader _markerLoader = MarkerLoader();
  CommunityRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _CommunityRouteState createState() => _CommunityRouteState();
}

class _CommunityRouteState extends State<CommunityRoute> {

  NetLoader netLoader = NetLoader();

  // zapis znaczników do bazy
  Future<void> postBackup() async {
    try{
      await netLoader.postToServer(
        endpoint: "/api/backup/trigger/",
        content: widget._markerLoader.getMarkersDescriptions(),
      );
    } on HttpException catch (e) {
      print(e);
    }
  }

  // TODO odczyt znaczników z bazy
  Future<void> getBackup() async {
    try{
      Map<String, Map> _markersDescriptions = await netLoader.getFromServer(
        endpoint: "/api/backup/trigger/",
      );

      _markersDescriptions.forEach((key, value) {
        print(value);
      });

      widget._markerLoader.saveMarkersFromBackup(content: _markersDescriptions);
    } on HttpException catch (e) {
      print(e);
    } on Exception catch (e) {
      print(e);
    }
  }

  Widget _tabWidget(){
    Color _color = (PrefService.get('ui_theme') == 'dark') ? Colors.white : Colors.black;
    return SizedBox(
      height: 300.0,
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car, color: _color)),
                  Tab(icon: Icon(Icons.directions_transit, color: _color)),
                  Tab(icon: Icon(Icons.directions_bike, color: _color)),
                ],
              ),
            ),
            SizedBox(
              height: 100.0,
              child: TabBarView(
                children: <Widget>[
                  Container(
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.green,
                  ),
                  Container(
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:
      // BODY
      PrefService.getString('token') == ''
          ? textInfo('You need to log in to use community options.' ?? '') :
      SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                'Community',
                style: header(),
              ),
              leading: Icon(Icons.language),
            ),

            // community dependent widgets
            PrefService.get('community_enabled') != true
                ? SizedBox.shrink() : ListTile(
              title: Text(
                'Back up your markers to server',
                style: bodyText(),
              ),
              trailing: Icon(Icons.backup),
              onLongPress: (){
                postBackup();
              },
            ),

            PrefService.get('community_enabled') != true
                ? SizedBox.shrink() : ListTile(
              title: Text(
                'Get your markers from Backup',
                style: bodyText(),
              ),
              trailing: Icon(Icons.file_download),
              onLongPress: (){
                getBackup();
              },
            ),

            _tabWidget(),

          ],
        ),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
