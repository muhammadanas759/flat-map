import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
// import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:preferences/preference_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flatmapp/resources/extensions.dart';


// dropdown list item class
class DropdownItem {
  const DropdownItem(this.name,this.icon);
  final String name;
  final Icon icon;
}

// ignore: must_be_immutable
class CommunityRoute extends StatefulWidget {

  // ignore: unused_field
  MarkerLoader _markerLoader = MarkerLoader();  // TODO unused element
  CommunityRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _CommunityRouteState createState() => _CommunityRouteState();
}

class _CommunityRouteState extends State<CommunityRoute> {

  NetLoader netLoader = NetLoader();
  List<dynamic> categoryCards;
  List<Map<String, dynamic>> _placesDescriptions = [];
  DropdownItem selectedPlaceCategory;
  Geolocator _geolocator = Geolocator();

  Map<String, dynamic> _formCategoryData = {
    'category': '',
    'range': 100,
    'position_x': 0,
    'position_y': 0
  };

  Future<LatLng> getCurrentPosition() async {
    Position temp = await _geolocator.getCurrentPosition();
    return temp.toLatLng();
  }

  List<DropdownItem> _dropdownListItems = <DropdownItem>[
    const DropdownItem('Theaters', Icon(Icons.local_activity, color:  const Color(0xFF167F67))),
    const DropdownItem('Cinemas', Icon(Icons.theaters, color:  const Color(0xFF167F67))),
    const DropdownItem('Casino', Icon(Icons.casino, color:  const Color(0xFF167F67))),
  ];

  Widget _buildMarkerRangeField() {
    return CounterFormField(
      initialValue: 100,
      onSaved: (value) => this._formCategoryData['range'] = value,
    );
  }

  void sendCategoryRequest(){
    // UPDATE USER POSITION
    getCurrentPosition().then((position){
      _formCategoryData['position_x'] = position.longitude;
      _formCategoryData['position_y'] = position.latitude;
      // send request to server via NetLoader and get category cards
      netLoader.categoryRequest(
        "/api/category/",
        _formCategoryData
      ).then((v){
        categoryCards = v;
//        setState(() {
//          categoryCards = v;
//        });
      });
    });
  }

  Widget _tabWidget(context){
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // counter field
          _buildMarkerRangeField(),
          // dropdown list
          new DropdownButton<DropdownItem>(
            hint:  Text("Select category"),
            value: selectedPlaceCategory,
            onChanged: (DropdownItem Value) {
              setState(() {
                selectedPlaceCategory = Value;
                _formCategoryData['category'] = selectedPlaceCategory.name;
                // send request after changing category
                sendCategoryRequest();
              });
            },
            items: _dropdownListItems.map((DropdownItem user) {
              return DropdownMenuItem<DropdownItem>(
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
          // places cards list
          _listPlaces(context)
        ],
      ),
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
                  title: Text(_placesDescriptions[index]['name'], style: bodyText()),
                  subtitle: Text(_placesDescriptions[index]['address'], style: footer()),
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

                          // use
                            // _placesDescriptions[index]['position_x']
                            // _placesDescriptions[index]['position_y']
                            // _placesDescriptions[index]['radius']

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

    // check permission
    _geolocator.checkGeolocationPermissionStatus().then((permission){
      // check permission status
      if(permission != GeolocationStatus.granted){
        print("GEOLOCATION PERMISSION IS NOT GRANTED YET");
      }
      print(permission);
    });

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
            ListTile( title: Text( 'Community',
                style: header(),
              ),
              leading: Icon(Icons.language),
            ),
            ListTile( title: Text( 'Select range of search and category of places '
                'to look up for places nearby in declared range.',
                style: bodyText(),
              ),
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
