import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:preferences/preferences.dart';

import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/map/utils/map_marker.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';


// https://medium.com/flutter-community/google-maps-in-flutter-i-feeb72354392
// https://codingwithjoe.com/google-maps-and-geolocation-in-flutter/

// TODO SUUUPER IMPORTANT LINK https://medium.com/swlh/working-with-geolocation-and-geocoding-in-flutter-and-integration-with-maps-16fb0bc35ede
class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  final Completer<GoogleMapController> _mapController = Completer();

  final String _preset = PrefService.get('ui_theme');

  // Map loading flag
  bool _isMapLoading = true;
  // Markers loading flag
  bool _areMarkersLoading = true;

  // Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  // current location of device
  LatLng _currentPosition = LatLng(52.466684, 16.926901);

  // data loaders
  IconsLoader _iconsLoader = IconsLoader();
  MarkerLoader _markerLoader = MarkerLoader();

  // markers set TODO markers set repair
  final Set<Marker> _markers = Set();

  // zones set - TODO zones repair
  Set<Circle> _zones = Set.from([
    Circle(
      circleId: CircleId('1'),
      center: LatLng(52.466684, 16.926901),
      radius: 10,
    ),
  ]);

  // temporary marker
  MapMarker temporaryMarker;

  // set custom map style
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style_$_preset.json');
    controller.setMapStyle(value);
  }

  // Init all the markers with network images and update the loading state.
  void _initMarkers() async {
    // notify about markers loading
    setState(() {
      _areMarkersLoading = true;
    });

    _markerLoader.loadMarkers();

    // notify about finished markers loading
    setState(() {
      _areMarkersLoading = false;
    });
  }

  // gets current location
  Future<LatLng> _getLocation() async {
    Position temp = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return LatLng(temp.latitude, temp.longitude);
  }

  // ===========================================================================
  // -------------------- GOOGLE MAPS WIDGET SECTION ---------------------------

  // Called when the Google Map widget is created.
  // Updates the map loading state and inits the markers.
  void _onMapCreated(GoogleMapController controller) {

    // notify about map loading
    setState(() {
      _isMapLoading = true;
    });

    // get current position and set it to var _currentPosition
    setState(() {
      _getLocation().then((value){_currentPosition = value;});
    });

    // set custom map style
    _setStyle(controller);

    // crete map controller
    _mapController.complete(controller);

    // notify about finished map loading
    setState(() {
      _isMapLoading = false;
    });

    // load markers
    _initMarkers();

    // TODO repair icons loader - no data in loaded icons map
    // temporary marker
//    temporaryMarker = MapMarker(
//      id: "1",
//      title: "new marker",
//      description: "temporary proposition",
//      position: LatLng(52.466684, 16.926901), // TODO repair temporary marker position - check link above class
//      range: 10,
//      icon: _iconsLoader.getIcon("default"),
//    );
  }

  // add marker in the place where user touched the map
  Future _mapTap(LatLng position) async {
    temporaryMarker.changePosition(position);
  }

  // open marker add formula if user pressed the map
  Future _mapLongPress(LatLng position) async {

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Google Map widget
        Opacity(
          opacity: _isMapLoading ? 0 : 1,
          child: GoogleMap(
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              // TODO initial camera position - change to phone position
              target: _currentPosition,
              zoom: _currentZoom,
            ),
            markers: _markers,
            circles: _zones,
            onMapCreated: (controller) => _onMapCreated(controller),

            // call this function when tapped on the map
            onTap: (position){
              _mapTap(position);
            },
            // call this function when long pressed on the map
            onLongPress: (position) {
              _mapLongPress(position);
            },
          ),
        ),

        // Map loading indicator
        Opacity(
          opacity: _isMapLoading ? 1 : 0,
          child: Center(child: CircularProgressIndicator()),
        ),

        // Map markers loading indicator
        if (_areMarkersLoading)
          textInfo('Loading map widget')

      ],
    );
  }
}
