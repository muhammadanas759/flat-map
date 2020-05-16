import 'dart:convert';

import 'package:flatmapp/resources/objects/loaders/actions_loader.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:http/http.dart' as http;
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
//  NetLoader netLoader = NetLoader();

  // TODO zapis znaczników do bazy
  void _postBackup()
  {
    print('post backup');
//    print(widget._markerLoader.markersDescriptions);
//    for(String key in widget._markerLoader.markersDescriptions.keys)
//      {
//        if(key != 'temporary')
//          print(widget._markerLoader.markersDescriptions[key]);
//
//      }
  }

  // TODO odczyt znaczników z bazy
  Future<void> _getBackup()
  async {
    print('get backup');
//    http.Response _response = await netLoader.getMarkers(endpoint: "api/backup/trigger/");
//    for(var object in jsonDecode(_response.body))
//      {
//        print(object);
//      }
  }

  Widget _tabWidget(){
    return SizedBox(
      height: 300.0,
      child: DefaultTabController(
        length: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _postBackup,
                  child: Text('Backup your markers'),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  onPressed: _getBackup,
                  child: Text('Get markers from Backup'),
                ),
              ]
            ),
            Container(
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
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

            // community widget
            PrefService.get('community_enabled') != true
                ? textInfo('Community options are disabled' ?? '') :
                  _tabWidget(),

            ListTile(
              title: Text(
                'FlatMapp Team @ 2020',
                style: footer(),
              ),
            ),
          ],
        ),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
