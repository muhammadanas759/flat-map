import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  final Completer<GoogleMapController> _mapController = Completer();

  // Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  // set map style
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  // Init [Fluster] and all the markers with network images and update the loading state.
  void _initMarkers() async {

  }

  // ===========================================================================
  // -------------------- GOOGLE MAPS WIDGET SECTION ---------------------------

  // Called when the Google Map widget is created. Updates the map loading state
  // and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    // set custom map style
    _setStyle(controller);

    // crete map controller
    _mapController.complete(controller);

    _initMarkers();

  }

  // Gets the markers and clusters to be displayed on the map
  // for the current zoom level and updates state.
  void _updateMarkers([double updatedZoom]) {

  }

  // add marker in the place where user touched the map
  Future _addMarkerLongPressed(LatLng latlang) async {

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Google Map widget
        Opacity(
          opacity: 1,
          child: GoogleMap(
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              // TODO initial camera position - change to phone position
              target: LatLng(52.466684, 16.926901),
              zoom: _currentZoom,
            ),
            markers: Set(),
            circles: Set(),
            onMapCreated: (controller) => _onMapCreated(controller),
            onCameraMove: (position) => _updateMarkers(position.zoom),
            // call this function when long pressed on the map
            onLongPress: (latlang) {
              _addMarkerLongPressed(latlang);
            },
          ),
        ),
      ],
    );
  }
}
