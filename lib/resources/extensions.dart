import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// add extension to double objects to round them to desired precision
extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }
}

// add extension to position objects to translate them to latlng
extension TranslatePosition on Position {
  LatLng toLatLng() {
    return LatLng(this.latitude, this.longitude);
  }
}

// add extension to translate string to boolean
extension TranslateString on String {
  bool toBool() {
    return this.toLowerCase() == 'true';
  }
}

bool toBool(String str, bool _default) {
  return str == "" || str == null ? _default : str.toLowerCase() == 'true';
}

double toDouble(String str, double _default) {
  return str == "" || str == null ? _default : double.parse(str);
}
