import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:volume/volume.dart';


// class providing action triggering
class TriggerLoader {
  // ===========================================================================
  // init variables
  Geolocator _geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
  );
  Position userLocation;
  StreamSubscription<Position> positionStream;

  TriggerLoader() {

    // check permission
    Geolocator().checkGeolocationPermissionStatus().then((permission){
      // TODO check permission status
    });

    positionStream = _geolocator.getPositionStream(locationOptions).listen(
      (Position position){operatePositionChange(position: position);}
    );
  }

  Future<List<Placemark>> placemarkFromAddress({String address}) async {
    // address type: Gronausestraat 710, Enschede
    return await _geolocator.placemarkFromAddress(address);
  }

  Future<List<Placemark>> placemarkFromCoordinates({LatLng position}) async {
    return await _geolocator.placemarkFromCoordinates(
        position.longitude, position.latitude
    );
  }

  Future<double> getDistanceBetweenPositions({LatLng position1, LatLng position2}) async {
    return await _geolocator.distanceBetween(
      position1.longitude, position1.latitude,
      position2.longitude, position2.latitude,
    );
  }

  void operatePositionChange({Position position}){
    // operate position change
    print(
        position == null ?
        'Unknown' :
        position.latitude.toString() + ', ' + position.longitude.toString()
    );
  }

  // ===========================================================================
  // define actions
  void mutePhone() async {
    await Volume.setVol(0, showVolumeUI: ShowVolumeUI.SHOW);
  }

  // ===========================================================================
}