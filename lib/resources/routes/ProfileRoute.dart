import 'package:flatmapp/resources/objects/loaders/icons_loader.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/models/flatmapp_marker.dart';
// import 'package:flatmapp/resources/objects/widgets/actions_list.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:preferences/preferences.dart';


// ignore: must_be_immutable
class ProfileRoute extends StatefulWidget {

  // data loader
  MarkerLoader _markerLoader = MarkerLoader();

  ProfileRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _ProfileRouteState createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {

  IconsLoader _iconsLoader = IconsLoader();

  NetLoader _netLoader = NetLoader();
  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // ---------------------------------------------------------------------------
  // ==================  ALERT DIALOGS =========================================
  Future<void> raiseAlertDialogRemoveMarker(String id) async {

    FlatMappMarker _marker = widget._markerLoader.getMarkerDescription(id: id);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Remove marker?"),
            content: Text(
                "You are about to remove marker\n"
                    "${_marker.title}\n"
                    "${_marker.description}."
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
                  widget._markerLoader.removeMarker(id: id);
                  // save markers state to file
                  widget._markerLoader.saveMarkers();
                  // dismiss alert
                  Navigator.of(context).pop();
                  // refresh cards
                  setState(() {});
                },
              ),
            ]
        );
      },
    );
  }

  Future<void> _raiseAlertDialogRemoveAllMarkers(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Remove ALL markers?"),
            content: Text(
                "You are about to remove all markers \n"
                    "from local storage.\n"
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
                child: Text("REMOVE. THEM. ALL."),
                onPressed:  () {
                  // remove all markers
                  setState(() {
                    widget._markerLoader.removeAllMarkers();
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

  // ===========================================================================
  // ---------------------------------------------------------------------------
  // ======================= COLUMNS ===========================================

  Widget _markersColumn(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Tooltip(
          message: "Remove all markers",
          child: ListTile(
            title: Text('Active markers: #' + (
              widget._markerLoader.getDescriptionsKeys().length - 1 > 0 ?
              '${widget._markerLoader.getDescriptionsKeys().length - 1}' : '0'
            ),
                style: bodyText()
            ),
            leading: Icon(Icons.bookmark_border),
            trailing: Icon(Icons.delete_forever),
            onTap: (){
              // remove all markers with alert dialog
              _raiseAlertDialogRemoveAllMarkers(context);
            },
          ),
        ),

        // list of active markers
        _listMarkers(context),

        ListTile(
          title: Text(
            'FlatMapp Team @ 2020',
            style: footer(),
          ),
        ),
      ],
    );
  }

  Widget _listMarkers(BuildContext context) {
    List<String> _markersDescriptionsKeys = widget._markerLoader.getDescriptionsKeys();

    // ActionsList _actionsList = ActionsList(widget._markerLoader);

    if (_markersDescriptionsKeys.length > 0){
      return Expanded(
        child:
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _markersDescriptionsKeys.length + 1,
            itemBuilder: (context, index) {
              if (index == _markersDescriptionsKeys.length){
                // add last element - card "add marker"
                return addActionCard(
                  tooltip: "Add marker",
                  onPressedMethod: () {
                    // set temporary as selected marker
                    PrefService.setString('selected_marker', "temporary");
                    // Navigate to the profile screen using a named route.
                    Navigator.pushNamed(context, '/map');
                  },
                );
              } else {
                // marker data for card
                String _id = _markersDescriptionsKeys.elementAt(index);
                FlatMappMarker _marker = widget._markerLoader.getMarkerDescription(id: _id);

                // don't add temporary marker to the list
                if(_id == 'temporary'){
                  return SizedBox.shrink();
                } else {
                  // add marker marker expandable card:
                  return  Card(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 5.0, left: 10.0, right: 10.0, bottom: 0.0
                      ),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                              _iconsLoader.markerImageLocal[_marker.icon]
                          ),
                        ),
                        title: Text(_marker.title, style: bodyText()),
                        subtitle: Text(_marker.description, style: footer()),
                        trailing: Icon(Icons.keyboard_arrow_down),
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
                              IconButton(
                                icon: Icon(Icons.delete_forever),
                                tooltip: 'Remove marker',
                                onPressed: () {
                                  // set up the AlertDialog
                                  raiseAlertDialogRemoveMarker(_id);
                                },
                              ),
                            ],
                          ),
                          // TODO add actions list to marker card in Profile
                          // _actionsList.buildActionsList(context, _id),
                        ],
                      ),
                    ),
                  );
                }
              }
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

  Widget _profileColumn(){
    return PrefService.get('token') == '' ?
    textInfo('You need to log in to use Profile' ?? '') :
    Column(
      children: <Widget>[
        ListTile(
          title: Text('Profile', style: header()),
          leading: Icon(Icons.account_circle),
        ),

        Tooltip(
          message: "Change username",
          child: ListTile(
            title: Text(
              'Username: ' + PrefService.getString("login"),
              style: bodyText(),
            ),
            leading: Icon(Icons.laptop),
            onTap: (){
              // TODO move to change form
            },
          ),
        ),

        BackupTile(
            text: 'Back up your markers to server',
            icon: Icon(Icons.backup),
            onLongPressMethod: (){
              _netLoader.postBackup(context, widget._markerLoader);
            }
        ),

        BackupTile(
            text: 'Get your markers from Backup',
            icon: Icon(Icons.file_download),
            onLongPressMethod: (){
              _netLoader.getBackup(context, widget._markerLoader);
            }
        ),

        ExpansionTile(
          leading: Icon(Icons.laptop),
          title: Text("Change user data", style: bodyText()),
          trailing: Icon(Icons.keyboard_arrow_down),
          children: <Widget>[
            ListTile(
              title: Text(
                'Change password',
                style: bodyText(),
              ),
              // leading: Icon(Icons.keyboard_arrow_right),
              trailing: Icon(Icons.compare_arrows),
              onTap: (){
                // move to change form
                Navigator.pushNamed(context, '/change_password');
              },
            ),

            ListTile(
              title: Text(
                'Erase account from system',
                style: bodyText(),
              ),
              trailing: Icon(Icons.remove_circle),
              leading: Icon(Icons.remove_circle),
              onTap: (){
                // move to account removal form
                Navigator.pushNamed(context, '/erase_account');
              },
            ),
          ],
        ),

        ListTile(
          title: Text(
            'FlatMapp Team @ 2020',
            style: footer(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = <Widget>[
      _markersColumn(),
      _profileColumn(),
    ];
    return Scaffold(
      appBar: appBar(),
      body: _views.elementAt(_selectedIndex),
      // SIDE PANEL MENU
      drawer: sideBarMenu(context),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            title: Text('Markers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, ),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: (int index) {
          if(index == 1 && PrefService.getString('token') == ''){
            // go to login page
            Navigator.pushNamed(context, '/login');
            // show message
            Fluttertoast.showToast(
              msg: "You need to log in to use Profile",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        }
      ),
    );
  }
}
