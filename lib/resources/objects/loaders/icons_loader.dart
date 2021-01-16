import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// class providing paths to markers icons
class IconsLoader {
  // ===========================================================================
  // more icons:
  // https://img.icons8.com/office/80/000000/marker.png
  // https://img.icons8.com/officel/80/000000/place-marker.png
  // https://img.icons8.com/dusk/80/000000/order-delivered.png

  final Map<String, String> markerImageLocal = {
    'default': 'assets/icons/marker.png',
    'pointer_place': 'assets/icons/place-marker.png',
    'pin': 'assets/icons/map-pin.png',
    'user': 'assets/icons/street-view.png',
    'clock': 'assets/icons/clock--v1.png',
    'post': 'assets/icons/new-post.png',
    'party': 'assets/icons/party-baloons.png',
    'gps': 'assets/icons/gps-device.png',
    'home': 'assets/icons/order-delivered.png',
    'office': 'assets/icons/link-company-parent.png',
    'factory': 'assets/icons/factory.png',
    'religion': 'assets/icons/city-church.png',
    'statue': 'assets/icons/statue.png',
    'parliament': 'assets/icons/parliament.png',
    'buildings': 'assets/icons/city-buildings.png',
    'tram': 'assets/icons/tram.png',
    'taxi': 'assets/icons/taxi.png',
    'train': 'assets/icons/train.png',
    'subway': 'assets/icons/subway.png',
    'car': 'assets/icons/car.png',
    'no_entry': 'assets/icons/no-entry.png',
    'no_mobile': 'assets/icons/no-mobile-devices.png',
    'biohazard': 'assets/icons/biohazard.png',
    'radioactive': 'assets/icons/radio-active.png',
    'water': 'assets/icons/water.png',
    'meal': 'assets/icons/meal.png',
  };

  Future<BitmapDescriptor> getMarkerImage(String name,
      {double targetWidth}) async {
    assert(name != null);

    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
          // TODO: after flutter update markers refuse to be resized like that
          // size: Size(targetWidth, targetWidth),
          ),
      markerImageLocal[name],
    );
  }
}
