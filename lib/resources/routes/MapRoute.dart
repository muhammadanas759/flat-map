import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:preferences/preferences.dart';

import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';


class MapRoute extends StatefulWidget {
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {

  // google map controller
  final Completer<GoogleMapController> _mapController = Completer();

  // location controller
  LatLng _userPosition = LatLng(52.466699, 16.926961);

  // map style preset
  final String _preset = PrefService.get('ui_theme');

  // Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  // data loader
  final MarkerLoader _markerLoader = MarkerLoader();

  // Map loading flag
  bool _isMapLoading = true;
  // Markers loading flag
  bool _areMarkersLoading = true;

  // temporary marker
  Marker temporaryMarker;

  @override
  void initState() {
    super.initState();
  }

  // set custom map style
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style_$_preset.json');
    controller.setMapStyle(value);
  }

  // Init all the markers with network images and update the loading state.
  void _initMarkers() async {

    await _markerLoader.loadMarkers();

    // notify about finished markers loading
    setState(() {
      _areMarkersLoading = false;
    });
  }

  void addMarker({Marker marker}) {
    setState(() {
      // adding a new marker to map
      _markerLoader.googleMarkers[_markerLoader.generateId()] = marker;
    });
  }

  // TODO change marker procedure
  void changeMarker({String id, Marker marker}){
    setState(() {
      // change marker
      _markerLoader.googleMarkers[
        _markerLoader.generateId()
      ] = marker;
    });
  }

  // ===========================================================================
  // -------------------- GOOGLE MAPS WIDGET SECTION ---------------------------

  // Called when the Google Map widget is created.
  // Updates the map loading state and inits the markers.
  void _onMapCreated(GoogleMapController controller) {

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
  }

  // add marker in the place where user touched the map
  Future _mapTap(LatLng position) async {
    Marker marker = await _markerLoader.temporaryMarker(position);
    addMarker(
      marker: marker
    );
  }

  // open marker add formula if user pressed the map
  Future _mapLongPress(LatLng position) async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:

      // GOOGLE MAPS
      PrefService.get('map_enabled') != true
        ? textInfo('Map is disabled' ?? '')
        : Stack(
        children: <Widget>[
          // Google Map widget
          Opacity(
            opacity: _isMapLoading ? 0 : 1,
            child: GoogleMap(
              myLocationEnabled: true,
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _userPosition,
                zoom: _currentZoom,
              ),
              markers: Set<Marker>.of(_markerLoader.googleMarkers.values),
              circles: Set<Circle>.of(_markerLoader.zones.values),
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
            textInfo('Loading markers')

        ],
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
