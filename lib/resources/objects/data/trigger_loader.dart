import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flatmapp/resources/extensions.dart';

import 'package:volume/volume.dart';


// class providing action triggering
class TriggerLoader {
  // ===========================================================================
  // init variables
  // geolocator API: https://pub.dev/documentation/geolocator/latest/geolocator/Geolocator-class.html
  Geolocator _geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
  );
  Position userLocation;
  StreamSubscription<Position> positionStream;

  TriggerLoader() {

//    // check permission
//    Geolocator().checkGeolocationPermissionStatus().then((permission){
//      // TODO check permission status
//      print(permission);
//    });
//
//    positionStream = _geolocator.getPositionStream(locationOptions).listen(
//      (Position position){operatePositionChange(position: position);}
//    );
  }

  Future<LatLng> getCurrentPosition() async {
    Position temp = await _geolocator.getCurrentPosition();
    return temp.toLatLng();
  }

  Future<LatLng> getPositionFromAddress({String address}) async {
    // address type: Gronausestraat 710, Enschede
    List<Placemark> tempPlaceList = await _geolocator.placemarkFromAddress(address);

    if (tempPlaceList != null && tempPlaceList.isNotEmpty) {
      // this is all you need
      Placemark placeMark  = tempPlaceList[0];
      return placeMark.position.toLatLng();
    } else {
      return null;
    }
  }

  Future<String> getAddressFromPosition({LatLng position}) async {

    List<Placemark> tempPlaceList = await _geolocator.placemarkFromCoordinates(
        position.latitude, position.longitude
    );

    if (tempPlaceList != null && tempPlaceList.isNotEmpty) {
      // this is all you need
      Placemark placeMark  = tempPlaceList[0];
      String name = placeMark.name;
      String subLocality = placeMark.subLocality;
      String locality = placeMark.locality;
      String administrativeArea = placeMark.administrativeArea;
      String postalCode = placeMark.postalCode;
      String country = placeMark.country;
      return "$subLocality $name, $locality, $administrativeArea $postalCode, $country";
    } else {
      return null;
    }
  }

  Future<double> getDistanceBetweenPositions({
    LatLng position1, LatLng position2
  }) async {
    return await _geolocator.distanceBetween(
      position1.latitude, position1.longitude,
      position2.latitude, position2.longitude,
    );
  }

  Future<double> getDistanceBetweenAddresses({
    String address1, String address2
  }) async {

    LatLng position1 = await getPositionFromAddress(address: address1);
    LatLng position2 = await getPositionFromAddress(address: address2);

    return await _geolocator.distanceBetween(
      position1.latitude, position1.longitude,
      position2.latitude, position2.longitude,
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