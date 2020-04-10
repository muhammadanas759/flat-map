import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';


// TODO SWIPE DOWN TO REFRESH
// https://medium.com/flutterpub/adding-swipe-to-refresh-to-flutter-app-b234534f39a7

class ProfileRoute extends StatefulWidget {
  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {

  // data loader
  final MarkerLoader _markerLoader = MarkerLoader();

  final IconsLoader icons = IconsLoader();

  @override
  void initState() {
    super.initState();
    _markerLoader.loadMarkers();
  }

  Widget listMarkers(BuildContext context) {
    if (_markerLoader.markersDescriptions.length > 0){
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _markerLoader.markersDescriptions.length,
        itemBuilder: (context, index) {

          // marker data for card
          var _id = _markerLoader.markersDescriptions.keys.elementAt(index);
          var _marker = _markerLoader.markersDescriptions[_id];

          // marker expandable card
          return Card(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 5.0, left: 10.0, right: 10.0, bottom: 0.0
              ),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                      _markerLoader.iconsLoader.markerImageLocal[_marker['icon']]
                  ),
                ),
                title: Text(_marker['title'], style: bodyText()),
                subtitle: Text(_marker['description'], style: footer()),
                trailing: Icon(Icons.keyboard_arrow_right),
                children: <Widget>[
                  Text(
                    'Range: ${_marker['range'].toString()}',
                    style: footer(),
                  ),
                  Text(
                    'Position:\n${_marker['position_x'].toString()},\n'
                        '${_marker['position_y'].toString()}',
                    style: footer(),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: 'Edit marker',
                    onPressed: () {
                      setState(() {
                        _markerLoader.editMarker();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    tooltip: 'Remove marker',
                    onPressed: () {
                      setState(() {
                        _markerLoader.removeMarker(id: _id);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return ListTile(
        title: Text('no markers found', style: footer()),
        leading: Icon(Icons.close),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:
      // BODY
      new ListView(
        children: <Widget>[
          ListTile(
            title: Text('Profile', style: header()),
            leading: Icon(Icons.account_circle),
          ),

          ListTile(
            title: Text('E-mail:', style: bodyText()),
            leading: Icon(Icons.mail_outline),
          ),

          ListTile(
            title: Text('Username:', style: bodyText()),
            leading: Icon(Icons.laptop),
          ),

          ListTile(
            title: Text('Number of markers:', style: bodyText()),
            leading: Icon(Icons.settings_backup_restore),
          ),

          ListTile(
            title: Text('Active markers:', style: bodyText()),
            leading: Icon(Icons.bookmark_border),
          ),

          // list of active markers
          listMarkers(context),

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
    );
  }
}
