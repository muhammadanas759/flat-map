import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';


// TODO SWIPE DOWN TO REFRESH
// https://medium.com/flutterpub/adding-swipe-to-refresh-to-flutter-app-b234534f39a7

class ProfileRoute extends StatefulWidget {

  // data loader
  MarkerLoader _markerLoader = MarkerLoader();

  ProfileRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {

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
            content: Text("You are about to remove marker\n"
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
    if (widget._markerLoader.markersDescriptions.length > 0){
      return SingleChildScrollView(child:
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget._markerLoader.markersDescriptions.length,
            itemBuilder: (context, index) {

              // marker data for card
              var _id = widget._markerLoader.markersDescriptions.keys.elementAt(index);
              var _marker = widget._markerLoader.markersDescriptions[_id];

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
                          widget._markerLoader.iconsLoader.markerImageLocal[_marker['icon']]
                      ),
                    ),
                    title: Text(_marker['title'], style: bodyText()),
                    subtitle: Text(_marker['description'], style: footer()),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
    //                      Text(
    //                        'Range: ${_marker['range'].toString()}',
    //                        style: footer(),
    //                      ),
    //                      Text(
    //                        'Position:\n${_marker['position_x'].toString()},\n'
    //                            '${_marker['position_y'].toString()}',
    //                        style: footer(),
    //                      ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            tooltip: 'Edit marker',
                            onPressed: () {
                              setState(() {
                                widget._markerLoader.editMarker();
                              });
                            },
                          ),
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
        onLongPress: (){
          widget._markerLoader.loadMarkers();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:
      // BODY
      SingleChildScrollView(
        child: new Column(
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
              title: Text('Active markers: #'
                  '${widget._markerLoader.markersDescriptions.length}',
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
      ),
      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
