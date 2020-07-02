import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
// import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';


// dropdown list item class
class DropdownItem {
  const DropdownItem(this.name,this.icon);
  final String name;
  final Icon icon;
}

// ignore: must_be_immutable
class CommunityRoute extends StatefulWidget {

  MarkerLoader _markerLoader = MarkerLoader();
  CommunityRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _CommunityRouteState createState() => _CommunityRouteState();
}

class _CommunityRouteState extends State<CommunityRoute> {

  NetLoader netLoader = NetLoader();

//  Widget _tabWidget(){
//    Color _color = (PrefService.get('ui_theme') == 'dark') ? Colors.white : Colors.black;
//    return SizedBox(
//      height: 300.0,
//      child: DefaultTabController(
//        length: 3,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Container(
//              child: TabBar(
//                tabs: [
//                  Tab(icon: Icon(Icons.directions_car, color: _color)),
//                  Tab(icon: Icon(Icons.directions_transit, color: _color)),
//                  Tab(icon: Icon(Icons.directions_bike, color: _color)),
//                ],
//              ),
//            ),
//            SizedBox(
//              height: 100.0,
//              child: TabBarView(
//                children: <Widget>[
//                  Container(
//                    color: Colors.grey,
//                  ),
//                  Container(
//                    color: Colors.green,
//                  ),
//                  Container(
//                    color: Colors.purple,
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  List<DropdownItem> _dropdownListItems = <DropdownItem>[
    const DropdownItem('Theaters', Icon(Icons.local_activity, color:  const Color(0xFF167F67))),
    const DropdownItem('Cinemas', Icon(Icons.theaters, color:  const Color(0xFF167F67))),
    const DropdownItem('Casino', Icon(Icons.casino, color:  const Color(0xFF167F67))),
  ];

  List<Map<String, dynamic>> _placesDescriptions = [];

  DropdownItem selectedPlaceCategory;

  Widget _tabWidget(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: new DropdownButton<DropdownItem>(
            hint:  Text("Select category"),
            value: selectedPlaceCategory,
            onChanged: (DropdownItem Value) {
              setState(() {
                // TODO operate change on list
                selectedPlaceCategory = Value;
              });
            },
            items: _dropdownListItems.map((DropdownItem user) {
              return  DropdownMenuItem<DropdownItem>(
                value: user,
                child: Row(
                  children: <Widget>[
                    user.icon,
                    SizedBox(width: 10,),
                    Text(
                      user.name,
                      style:  TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        _listPlaces(context)
      ],
    );
  }

  Widget _listPlaces(BuildContext context) {
    if (_placesDescriptions.length > 0){
      return Expanded(
        child:
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _placesDescriptions.length + 1,
          itemBuilder: (context, index) {
            // add placemark expandable card:
            return  Card(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 5.0, left: 10.0, right: 10.0, bottom: 0.0
                ),
                child: ExpansionTile(
//                  leading: CircleAvatar(
//                    backgroundColor: Colors.white,
//                    backgroundImage: AssetImage(
//                        _iconsLoader.markerImageLocal[_marker.icon]
//                    ),
//                  ),
                  title: Text(_placesDescriptions[index]['title'], style: bodyText()),
                  subtitle: Text(_placesDescriptions[index]['description'], style: footer()),
                  trailing: Icon(Icons.keyboard_arrow_down),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.location_searching),
                          tooltip: 'Find placemark',
                          onPressed: () {
//                            // set selected marker id for map screen
//                            PrefService.setString('selected_marker', _id);
//                            // Navigate to the profile screen using a named route.
//                            Navigator.pushNamed(context, '/map');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          tooltip: 'Add marker',
                          onPressed: () {
                            // TODO add placemark method
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
        title: Text('no places found', style: footer()),
        leading: Icon(Icons.error_outline),
      );
    }
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

            _tabWidget(context),  // TODO new community widget
          ],
        ),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
