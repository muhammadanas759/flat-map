import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/map/utils/map_marker.dart';
import 'package:flatmapp/resources/objects/map/utils/map_helper.dart';

import '../widgets/text_styles.dart';


class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  final Completer<GoogleMapController> _mapController = Completer();

  // loaders for icons and markers
  final IconsLoader _iconsLoader = IconsLoader();
  final MarkerLoader _markersLoader = MarkerLoader();

  // Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  // Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  // Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  // [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  // Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  // Map loading flag
  bool _isMapLoading = true;

  // Markers loading flag
  bool _areMarkersLoading = true;

  // create circles
  Set<Circle> _circles = Set.from([
    Circle(circleId: CircleId('1'),center: LatLng(52.466684, 16.926901), radius: 100,),
  ]);

  // set map style
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  // Init [Fluster] and all the markers with network images and update the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    // load markers on class contruction
    await _markersLoader.loadMarkers();

    // for each marker in loader
    for (Map markerMap in _markersLoader.markersMap) {

      // get marker image
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromAssets(
              _iconsLoader.markerImageUrl[markerMap['icon']]
          );

      // add MapMarker object to the list
      markers.add(
        MapMarker(
          id: _markersLoader.markersMap.indexOf(markerMap).toString(),
          position: LatLng(markerMap['position'][0], markerMap['position'][1]),
          icon: markerImage,
        ),
      );
    }

    // initialize cluster manager
    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
      _iconsLoader.markerImageUrl['pointer_place'],
    );

    // update markers states
    _updateMarkers();
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

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  // Gets the markers and clusters to be displayed on the map for the current zoom level and
  // updates state.
  void _updateMarkers([double updatedZoom]) {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    _markers
      ..clear()
      ..addAll(
          MapHelper.getClusterMarkers(_clusterManager, _currentZoom)
      );

    // save new markers
    _markersLoader.saveMarkers();

    // reload application state
    setState(() {
      _areMarkersLoading = false;
    });
  }

  // add marker in the place where user touched the map
  Future _addMarkerLongPressed(LatLng latlang) async {
    _markersLoader.markersMap.add(
      {'position': [latlang.latitude, latlang.longitude], 'icon': 'home'}
    );
    _initMarkers();
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
              target: LatLng(52.466684, 16.926901),
              zoom: _currentZoom,
            ),
            markers: _markers,
            circles: _circles,
            onMapCreated: (controller) => _onMapCreated(controller),
            onCameraMove: (position) => _updateMarkers(position.zoom),
            onLongPress: (latlang) {
              _addMarkerLongPressed(latlang); //we will call this function when pressed on the map
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
          textInfo('Loading')
      ],
    );
  }
}
