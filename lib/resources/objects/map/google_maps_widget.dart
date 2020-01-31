import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'utils/map_marker.dart';
import 'utils/map_helper.dart';

import '../widgets/text_styles.dart';


class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {

  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  // list of marker data
  final List<Map> markersMap = [
    {'position': LatLng(41.147125, -8.611249), 'icon': 'home'},
    {'position': LatLng(41.145599, -8.610691), 'icon': 'pointer'},
    {'position': LatLng(41.145645, -8.614761), 'icon': 'taxi'},
    {'position': LatLng(41.146775, -8.614913), 'icon': 'water'},
    {'position': LatLng(41.146982, -8.615682), 'icon': 'parliament'},
    {'position': LatLng(41.140558, -8.611530), 'icon': 'tram'},
    {'position': LatLng(41.138393, -8.608642), 'icon': 'pin'},
    {'position': LatLng(41.137860, -8.609211), 'icon': 'factory'},
    {'position': LatLng(41.138344, -8.611236), 'icon': 'meal'},
    {'position': LatLng(41.139813, -8.609381), 'icon': 'biohazard'},
  ];

  /// Map of icon images urls used on normal markers
  final Map markerImageUrl = {
    'pointer':       'https://img.icons8.com/office/80/000000/marker.png',
    'pointer_place': 'https://img.icons8.com/officel/80/000000/place-marker.png',
    'pin':           'https://img.icons8.com/office/80/000000/map-pin.png',

    'user':          'https://img.icons8.com/office/80/000000/street-view.png',
    'clock':         'https://img.icons8.com/color/48/000000/clock--v1.png',
    'post':          'https://img.icons8.com/office/80/000000/new-post.png',
    'party':         'https://img.icons8.com/office/80/000000/party-baloons.png',
    'gps':           'https://img.icons8.com/office/80/000000/gps-device.png',

    'home':          'https://img.icons8.com/dusk/80/000000/order-delivered.png',
    'office':        'https://img.icons8.com/office/80/000000/link-company-parent.png',
    'factory':       'https://img.icons8.com/office/80/000000/factory.png',
    'religion':      'https://img.icons8.com/office/80/000000/city-church.png',
    'statue':        'https://img.icons8.com/office/80/000000/statue.png',
    'parliament':    'https://img.icons8.com/office/80/000000/parliament.png',
    'buildings':     'https://img.icons8.com/office/80/000000/city-buildings.png',

    'tram':          'https://img.icons8.com/office/80/000000/tram.png',
    'taxi':          'https://img.icons8.com/office/80/000000/taxi.png',
    'train':         'https://img.icons8.com/office/80/000000/train.png',
    'subway':        'https://img.icons8.com/office/80/000000/subway.png',
    'car':           'https://img.icons8.com/office/80/000000/car.png',

    'no_entry':      'https://img.icons8.com/office/80/000000/no-entry.png',
    'no_mobile':     'https://img.icons8.com/office/80/000000/no-mobile-devices.png',

    'biohazard':     'https://img.icons8.com/office/80/000000/biohazard.png',
    'radioactive':   'https://img.icons8.com/office/80/000000/radio-active.png',
    'water':         'https://img.icons8.com/office/80/000000/water.png',
    'meal':          'https://img.icons8.com/office/80/000000/meal.png',
  };

  /// Init [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (Map markerMap in markersMap) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(
              markerImageUrl[markerMap['icon']]
          );

      markers.add(
        MapMarker(
          id: markersMap.indexOf(markerMap).toString(),
          position: markerMap['position'],
          icon: markerImage,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
      markerImageUrl['pointer_place'],
    );

    _updateMarkers();
  }

  // ===========================================================================
  // -------------------- GOOGLE MAPS WIDGET SECTION ---------------------------

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
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
      ..addAll(MapHelper.getClusterMarkers(_clusterManager, _currentZoom));

    setState(() {
      _areMarkersLoading = false;
    });
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
              target: LatLng(41.143029, -8.611274),
              zoom: _currentZoom,
            ),
            markers: _markers,
            onMapCreated: (controller) => _onMapCreated(controller),
            onCameraMove: (position) => _updateMarkers(position.zoom),
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