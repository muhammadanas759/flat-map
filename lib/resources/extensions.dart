import 'dart:math';

import 'package:flatmapp/resources/objects/models/action.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// add extension to double objects to round them to desired precision
extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}

// add extension to position objects to translate them to latlng
extension TranslatePosition on Position {
  LatLng toLatLng() {
    return LatLng(this.latitude, this.longitude);
  }
}
