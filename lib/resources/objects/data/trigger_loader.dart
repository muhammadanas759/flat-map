import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flatmapp/resources/extensions.dart';

import 'package:volume/volume.dart';


// class providing action triggering
class TriggerLoader {
  // ===========================================================================
  // init variables
  // geolocator API: https://pub.dev/documentation/geolocator/latest/geolocator/Geolocator-class.html
  Geolocator _geolocator;
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      timeInterval: 1000,
      distanceFilter: 10
  );
  Position userLocation;

  // ignore or add somewhere subscription.cancel()
  // so that app would be able to do some cleanup in stream
  // ignore: cancel_subscriptions
  StreamSubscription<Position> positionStream;

  // notifications on location change
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  TriggerLoader(
      Geolocator _passedGeolocator,
      FlutterLocalNotificationsPlugin passedFlutterLocalNotificationsPlugin
  ) {

    _geolocator = _passedGeolocator;
    flutterLocalNotificationsPlugin = passedFlutterLocalNotificationsPlugin;

    // listen to position changes
    positionStream = _geolocator.getPositionStream(locationOptions).listen(
      (Position position){operatePositionChange(position: position);}
    );
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

  // ===========================================================================

  void operateIsolatedInput(){

  }

  void operatePositionChange({Position position}){
    // operate position change
    print("POSITION CHANGE DETECTED");
    print(
        position == null ? 'Unknown' :
        position.latitude.toString() + ', ' + position.longitude.toString()
    );

//    _showNotificationWithDefaultSound(
//      title: "POSITION CHANGE DETECTED",
//      content: "CITIZEN NR 26108, STAY AT HOME"
//    );

    // TODO check if user entered any marker
    // ignore: dead_code
    if(false){
      // get actions declared for this marker

      // operate these actions
    }
  }

  // ===========================================================================
  // define actions

  // push notifications
  // https://medium.com/@nitishk72/flutter-local-notification-1e43a353877b
  Future _showNotificationWithDefaultSound({String title, String content}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your channel description',
        importance: Importance.Max,
        priority: Priority.High
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      content,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void mutePhone() async {
    await Volume.setVol(0, showVolumeUI: ShowVolumeUI.SHOW);
  }

  // https://pub.dev/packages/volume#-example-tab-
  // https://pub.dev/packages/flutter_blue
  // https://pub.dev/packages/connectivity


  // ===========================================================================
}