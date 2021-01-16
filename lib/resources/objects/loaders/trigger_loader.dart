import 'dart:async';

import 'package:flatmapp/resources/extensions.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/models/flatmapp_action.dart';
import 'package:flatmapp/resources/objects/models/flatmapp_marker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:volume/volume.dart';
import 'package:wifi_iot/wifi_iot.dart';

// class providing action triggering
class TriggerLoader {
  // ===========================================================================
  // init variables
  MarkerLoader _markerLoader;

  // timer as workaround to load file every x minutes
  Timer timer;

  // geolocator API: https://pub.dev/documentation/geolocator/latest/geolocator/Geolocator-class.html
  Geolocator _geolocator = Geolocator();
  LocationOptions locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high, timeInterval: 1000, distanceFilter: 10);

  // ignore or add somewhere subscription.cancel()
  // so that app would be able to do some cleanup in stream
  // ignore: cancel_subscriptions
  StreamSubscription<Position> positionStream;

  // notifications on location change
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // list of previously activated markers
  List<String> _activatedNow = [];
  List<String> _activatedPreviously = [];

  TriggerLoader(Geolocator _passedGeolocator, MarkerLoader _passedMarkerLoader,
      FlutterLocalNotificationsPlugin passedFlutterLocalNotificationsPlugin) {
    _geolocator = _passedGeolocator;
    _markerLoader = _passedMarkerLoader;
    _flutterLocalNotificationsPlugin = passedFlutterLocalNotificationsPlugin;
    // listen to position changes
    positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      operatePositionChange(position: position);
    });

    // checks if file with markers was modified and if it was loads markers
    timer = Timer.periodic(Duration(seconds: 5),
        (Timer t) => _markerLoader.updateMarkersOnFileChange());
  }

  Future<bool> checkGeolocationModule() async {
    return await _geolocator.isLocationServiceEnabled();
  }

  Future<LatLng> getCurrentPosition() async {
    Position temp = await _geolocator.getCurrentPosition();
    return temp.toLatLng();
  }

  Future<LatLng> getPositionFromAddress({String address}) async {
    // address type: Gronausestraat 710, Enschede
    List<Placemark> tempPlaceList =
        await _geolocator.placemarkFromAddress(address);

    if (tempPlaceList != null && tempPlaceList.isNotEmpty) {
      // this is all you need
      Placemark placeMark = tempPlaceList[0];
      return placeMark.position.toLatLng();
    } else {
      return null;
    }
  }

  Future<String> getAddressFromPosition({LatLng position}) async {
    List<Placemark> tempPlaceList = await _geolocator.placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (tempPlaceList != null && tempPlaceList.isNotEmpty) {
      // this is all you need
      Placemark placeMark = tempPlaceList[0];
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

  Future<double> getDistanceBetweenPositions(
      LatLng position1, LatLng position2) async {
    return await _geolocator.distanceBetween(
      position1.latitude,
      position1.longitude,
      position2.latitude,
      position2.longitude,
    );
  }

  Future<double> getDistanceBetweenAddresses(
      {String address1, String address2}) async {
    LatLng position1 = await getPositionFromAddress(address: address1);
    LatLng position2 = await getPositionFromAddress(address: address2);

    return await _geolocator.distanceBetween(
      position1.latitude,
      position1.longitude,
      position2.latitude,
      position2.longitude,
    );
  }

  Future<void> getActivatedMarkers(LatLng user) async {
    _markerLoader.getDescriptionsKeys().forEach((String markerID) {
      FlatMappMarker markerData = _markerLoader.getMarkerDescription(markerID);
      LatLng markerPos = LatLng(markerData.position_x, markerData.position_y);
      double range = markerData.range;

      // check if marker should be activated
      getDistanceBetweenPositions(user, markerPos).then((distance) {
        if (distance <= range) {
          if (!_activatedNow.contains(markerID) &&
              !_activatedPreviously.contains(markerID))
            _activatedNow.add(markerID);
        } else {
          if (_activatedPreviously.contains(markerID))
            _activatedPreviously
                .removeAt(_activatedPreviously.indexOf(markerID));
        }
      });
    });
  }

  // ===========================================================================
  Future<void> operatePositionChange({Position position}) async {
    // get activated markers
    await getActivatedMarkers(position.toLatLng());

    //print("all markers: ");
    //print(_markerLoader.getMarkersDescriptions());
    //print("activated now: $_activatedNow");
    //print("activated previously: $_activatedPreviously");
    // TODO operate all actions possible
    for (String markerId in _activatedNow) {
      // activate marker actions
      //print("activated marker: $markerId");
      //print("activated actions:");
      for (FlatMappAction action
          in _markerLoader.getMarkerActions(id: markerId)) {
        print(action);
        switch (action.icon) {
          case "mute":
            mutePhone(action.parameters);
            break;
          case "notification":
            _showNotificationWithDefaultSound(action.parameters);
            break;
          case "wi-fi":
            controlWIFI(action.parameters);
            break;
          default:
            print("default action not recognized : $action");
            break;
        }
      }

      // add marker to previously activated list
      _activatedPreviously.add(markerId);
    }

    // remove markers from current tick that were activated and should not be activated again
    // now it's just for safety
    _activatedNow.removeWhere((item) => _activatedPreviously.contains(item));
  }

  // ===========================================================================
  // define actions

  // push notifications
  // https://medium.com/@nitishk72/flutter-local-notification-1e43a353877b
  Future _showNotificationWithDefaultSound(
      Map<String, dynamic> parameters) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'flutter_channel_id',
        'flutter_channel_name',
        'flutter_channel_description',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      parameters['param1'], // title
      parameters['param2'], // content
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void controlWIFI(Map<String, dynamic> parameters) {
    WiFiForIoTPlugin.setEnabled(true);
    // TODO turn on WIFI doesnt work in subprocess
  }

  void mutePhone(Map<String, dynamic> parameters) async {
    await Volume.setVol(0, showVolumeUI: ShowVolumeUI.SHOW);

    // TODO Mute phones returns null pointer exeption when called
    // await Volume.setVol(0);
    print("called phone mute");
  }

// https://pub.dev/packages/volume#-example-tab-
// https://pub.dev/packages/flutter_blue
// https://pub.dev/packages/connectivity

// ===========================================================================
}
