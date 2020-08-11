import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:preferences/preference_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flatmapp/resources/extensions.dart';

// ignore: must_be_immutable
class CommunityRoute extends StatefulWidget {

  MarkerLoader _markerLoader = MarkerLoader();  // TODO unused element
  CommunityRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _CommunityRouteState createState() => _CommunityRouteState();
}

class _CommunityRouteState extends State<CommunityRoute> {

  NetLoader netLoader = NetLoader();
  List<Map<String, dynamic>> _placesDescriptions = [];
  Geolocator _geolocator = Geolocator();

  // form controllers:
  TextEditingController _categoryController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool if_already_added = false;
  String _last_search = "text"; // something not empty

  Map<String, dynamic> _formCategoryData = {
    'category': '',
    'range': 100,
    'position_x': 0,
    'position_y': 0,
    'approximate': false,
    'language': 'EN',
  };

  Future<LatLng> getCurrentPosition() async {
    Position temp = await _geolocator.getCurrentPosition();
    return temp.toLatLng();
  }

  void addMarkerFromCategory(Map<String, dynamic> item, String _id){

    if (item['radius'] == null) {
      item['radius'] = 110;
    }

    widget._markerLoader.addMarker(
      id: _id,
      position: LatLng(
        item['position_x'],
        item['position_y']
      ),
      icon: PrefService.get('community_icon'),
      title: item['name'],
      description: item['address'],
      range: item['radius'].toDouble(),
      actions: [],
    );
  }

  Widget _buildMarkerRangeField() {
    return CounterFormField(
      initialValue: _formCategoryData['range'],
      onSaved: (value) => this._formCategoryData['range'] = value,
    );
  }

  Widget _buildCategoryTextFieldAndButton() {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextFormField(
                controller: _categoryController,
                style: bodyText(),
                decoration: textFieldStyle(
                  labelTextStr: "Category name",
                  hintTextStr: "please provide category for search"
                ),
                onSaved: (String value) {
                  _formCategoryData['category'] = value;
                },
                textInputAction: TextInputAction.next,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'This field can not be empty';
                  }
                  return null;
                },
                onFieldSubmitted: (String value) {
                  _formCategoryData['category'] = value;
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onChanged: (String value) {
                  _formCategoryData['category'] = value;
                },
              ),
            ),
          ),
          Expanded(
            child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: ListTile(
                  title: Text('Search', style: bodyText()),
                  trailing: Icon(Icons.search),
                  onTap: (){
                    if (_formKey.currentState.validate()) {
                      if (_last_search != _formCategoryData['category']){
                        // send request
                        sendCategoryRequest();
                      } else {
                        netLoader.showToast("No new category to search");
                      }
                    } else {
                      print("field didn't pass validation");
                    }
                  }
              ),
            ),
          ),
        ]
      )
    );
  }

  Future<void> sendCategoryRequest() async {

    // get phone localization language code
    _formCategoryData['language'] =  Localizations.localeOf(context).languageCode;

    // UPDATE USER POSITION
    _geolocator.isLocationServiceEnabled().then((status){
      if (status == false){
        netLoader.showToast("Geolocation is turned off");
      } else {
        netLoader.checkNetworkConnection().then((connected){
          if(connected){
            getCurrentPosition().then((position){
              _formCategoryData['position_x'] = position.latitude;
              _formCategoryData['position_y'] = position.longitude;
              // send request to server via NetLoader and get category cards
              netLoader.categoryRequest(
                "/api/category/",
                _formCategoryData
              ).then((v){
                setState(() {
                  _placesDescriptions = v;
                  _last_search = _formCategoryData['category'];
                });
              });
            });
            // reset control of category add button
            if_already_added = false;
          } else {
            netLoader.showToast("Network connection is off");
          }
        });
      }
    });
  }

  Widget addAllPlaces(BuildContext context){
    return ListTile(
      title: Text( 'Add all placemarks from list',
        style: bodyText(),
      ),
      leading: Icon(Icons.add_circle_outline),
      onTap: () {
        for (int index=0; index < _placesDescriptions.length; index++) {
          // add placemark method
          String _id = widget._markerLoader.generateId();
          print(_placesDescriptions[index]);
          addMarkerFromCategory(_placesDescriptions[index], _id);
        }
        setState(() {
          if_already_added = true;
        });
        netLoader.showToast("All placemarks added successfully");
      },
    );
  }

  Widget _iconChangeButton(){
    return Expanded(
      child: SizedBox(
        height: 60.0,
        // icon change button
        child: Container(
            child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: FlatButton(
                    onPressed: (){
                      // Navigate to the icons screen using a named route.
                      Navigator.pushNamed(context, '/community_icons');
                    },
                    padding: EdgeInsets.all(0.0),
                    child: Image.asset(
                      widget._markerLoader.iconsLoader.markerImageLocal[
                        PrefService.get('community_icon')
                      ]
                    )
                )
            )
        ),
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
          itemCount: _placesDescriptions.length,
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
                            // move temporary marker to new position
                            widget._markerLoader.addTemporaryMarker(
                              LatLng(
                                _placesDescriptions[index]['position_x'],
                                _placesDescriptions[index]['position_y']
                              )
                            );
                            // set selected marker
                            PrefService.setString('selected_marker', "temporary");
                            // Navigate to the profile screen using a named route.
                            Navigator.pushNamed(context, '/map');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          tooltip: 'Delete placemark from list',
                          onPressed: () {
                            // remove element from list
                            setState(() {
                              _placesDescriptions.removeAt(index);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          tooltip: 'Add marker',
                          onPressed: () {
                            // add placemark method
                            String _id = widget._markerLoader.generateId();

                            addMarkerFromCategory(_placesDescriptions[index], _id);

                            // set selected marker
                            PrefService.setString('selected_marker', _id);
                            // Navigate to the profile screen using a named route.
                            Navigator.pushNamed(context, '/map');
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
//    _geolocator.checkGeolocationPermissionStatus().then((permission){
//      // check permission status
//      if(permission != GeolocationStatus.granted){
//        print("GEOLOCATION PERMISSION IS NOT GRANTED YET");
//      }
//      print(permission);
//    });

    return Scaffold(
      appBar: appBar(),
      body:
      // BODY
      PrefService.getString('token') == ''
          ? textInfo('You need to log in to use community options.' ?? '') :
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile( title: Text( 'Community',
                style: header(),
              ),
              leading: Icon(Icons.language),
            ),
            ListTile(
              title: Text( 'Select range of search and category of places '
                'to look up for places nearby in declared range.',
                style: bodyText(),
              ),
            ),

            _buildMarkerRangeField(),

            CheckboxListTile(
              title: Text(
                "Use approximated range",
                style: bodyText(),
              ),
              value: _formCategoryData['approximate'],
              onChanged: (value) {
                setState(() {
                  _formCategoryData['approximate'] = value;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing, //or leading
            ),

            // dropdown list
            _buildCategoryTextFieldAndButton(),

            _placesDescriptions.length != 0 && !if_already_added ?
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: addAllPlaces(context),
                  ),
                  SizedBox(
                    width: 100,
                    child: _iconChangeButton()
                  ),
                ],
              )
            : SizedBox.shrink(),

            // places cards list
            SizedBox(
              height: 400, // fixed height
              child: _listPlaces(context),
            ),
          ],
        ),
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
