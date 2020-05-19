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

  NetLoader netLoader = NetLoader();

  // TODO zapis znaczników do bazy
  Future<void> postBackup() async {
    http.Response _response = await netLoader.postToServer(
      endpoint: "/api/backup/trigger/",
      content: widget._markerLoader.getMarkersDescriptions(),
    );

    print(_response.body);

//    for(String key in _markersDescriptions.keys) {
//      if(key != 'temporary'){
//        print(_markersDescriptions[key]);
//      }
//    }
  }

  // TODO odczyt znaczników z bazy
  Future<void> getBackup() async {
    Map<String, Map> _markersDescriptions = await netLoader.getFromServer(
      endpoint: "/api/backup/trigger/",
    );

    _markersDescriptions.forEach((key, value) {
      print(value);
    });

    widget._markerLoader.saveMarkersFromBackup(content: _markersDescriptions);
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

//            PrefService.get('community_enabled') != true
//                ? textInfo('Community options are disabled' ?? '') : _tabWidget(),

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
