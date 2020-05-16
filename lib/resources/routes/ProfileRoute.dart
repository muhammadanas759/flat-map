import 'package:flatmapp/resources/objects/loaders/icons_loader.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';


class ProfileRoute extends StatefulWidget {

  // data loader
  MarkerLoader _markerLoader = MarkerLoader();

  ProfileRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {

  IconsLoader _iconsLoader = IconsLoader();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _raiseAlertDialog(BuildContext context, var id, var _marker) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove marker?"),
          content: Text(
            "You are about to remove marker\n"
            "${_marker['title']}\n"
            "${_marker['description']}."
          ),
          actions: [
            // set up the buttons
            FlatButton(
              child: Text("no nO NO"),
              onPressed:  () {
                // dismiss alert
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("HELL YEAH"),
              onPressed:  () {
                // remove marker
                setState(() {
                  widget._markerLoader.removeMarker(id: id);
                  // save markers state to file
                  widget._markerLoader.saveMarkers();
                });
                // dismiss alert
                Navigator.of(context).pop();
              },
            ),
          ]
        );
      },
    );
  }

  Widget listMarkers(BuildContext context) {
    List<String> _markersDescriptionsKeys = widget._markerLoader.getDescriptionsKeys();

    if (_markersDescriptionsKeys.length > 0){
      return Expanded(
        child:
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _markersDescriptionsKeys.length,
            itemBuilder: (context, index) {

              // marker data for card
              var _id = _markersDescriptionsKeys.elementAt(index);
              var _marker = widget._markerLoader.getMarkerDescription(id: _id);

              // marker expandable card
              return _id == 'temporary' ? SizedBox.shrink() : Card(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5.0, left: 10.0, right: 10.0, bottom: 0.0
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                          _iconsLoader.markerImageLocal[_marker['icon']]
                      ),
                    ),
                    title: Text(_marker['title'], style: bodyText()),
                    subtitle: Text(_marker['description'], style: footer()),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.location_searching),
                            tooltip: 'Find marker',
                            onPressed: () {
                              // set selected marker id for map screen
                              PrefService.setString('selected_marker', _id);
                              // Navigate to the profile screen using a named route.
                              Navigator.pushNamed(context, '/map');
                            },
                          ),
//                          IconButton(
//                            icon: Icon(Icons.edit),
//                            tooltip: 'Edit marker',
//                            onPressed: () {
//                              // set selected marker id for map screen
//                              PrefService.setString('selected_marker', _id);
//                              // Navigate to the profile screen using a named route.
//                              Navigator.pushNamed(context, '/map');
//                            },
//                          ),
                          IconButton(
                            icon: Icon(Icons.delete_forever),
                            tooltip: 'Remove marker',
                            onPressed: () {
                              // set up the AlertDialog
                              _raiseAlertDialog(context, _id, _marker);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      );
    } else {
      return ListTile(
        title: Text('no markers found', style: footer()),
        leading: Icon(Icons.error_outline),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
          children: <Widget>[
            ListTile(
              title: Text('Profile', style: header()),
              leading: Icon(Icons.account_circle),
            ),

            ListTile(
              title: Text(
                'Username: ' + PrefService.getString("login"),
                style: bodyText(),
              ),
              leading: Icon(Icons.laptop),
              onTap: (){
                // TODO move to change form
              },
            ),

            ListTile(
              title: Text(
                'Change user login and/or password',
                style: bodyText(),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onLongPress: (){
                // TODO move to change form
              },
            ),
            ListTile(
              title: Text(
                'Back up markers to server',
                style: bodyText(),
              ),
              trailing: Icon(Icons.backup),
              onLongPress: (){
                // TODO back up markers
              },
            ),
            ListTile(
              title: Text(
                'Download markers from server',
                style: bodyText(),
              ),
              trailing: Icon(Icons.file_download),
              onLongPress: (){
                // TODO download markers
              },
            ),

            ListTile(
              title: Text('Active markers: #'
                  '${widget._markerLoader.getDescriptionsKeys().length - 1}',
                  style: bodyText()
              ),
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
