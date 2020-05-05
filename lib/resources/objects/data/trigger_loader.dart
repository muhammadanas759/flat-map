import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flatmapp/resources/extensions.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';

import 'package:geolocator/geolocator.dart';
import 'package:watcher/watcher.dart';

import 'package:volume/volume.dart';


// class providing action triggering
class TriggerLoader {
  // ===========================================================================
  // init variables
  MarkerLoader _markerLoader;

  // geolocator API: https://pub.dev/documentation/geolocator/latest/geolocator/Geolocator-class.html
  Geolocator _geolocator = Geolocator();
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
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // list of previously activated markers
  List<String> _activatedNow = [];
  List<String> _activatedPreviously = [];

  TriggerLoader(
      Geolocator _passedGeolocator,
      MarkerLoader _passedMarkerLoader,
      FlutterLocalNotificationsPlugin passedFlutterLocalNotificationsPlugin
  ) {

    _geolocator = _passedGeolocator;
    _markerLoader = _passedMarkerLoader;
    _flutterLocalNotificationsPlugin = passedFlutterLocalNotificationsPlugin;

    // listen to position changes
    positionStream = _geolocator.getPositionStream(locationOptions).listen(
      (Position position){operatePositionChange(position: position);}
    );

    // listen to marker storage file changes
    _markerLoader.getFilePath().then((String path){
      try {
        // TODO add working watcher on markers file - current one throws up
        final watcher = FileWatcher(path);

        // ignore or add somewhere subscription.cancel()
        // so that app would be able to do some cleanup in stream
        // ignore: unused_local_variable, cancel_subscriptions
        final subscription = watcher.events.listen((event) {
          // reload markers on file storage change
          switch (event.type) {
            case ChangeType.ADD:
              print('Added file');
              _markerLoader.loadMarkers();
              break;
            case ChangeType.MODIFY:
              print('Modified');
              _markerLoader.loadMarkers();
              break;
            case ChangeType.REMOVE:
              print('Removed');
              _markerLoader.loadMarkers();
          }
        });
      } catch (e) {
        // No specified type, handles all
        print('Unknown error: $e');
      }
    });
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

  Future<double> getDistanceBetweenPositions(
    LatLng position1, LatLng position2
  ) async {
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

  List<String> getActivatedMarkers(LatLng user) {
    List<String> activated = [];

    _markerLoader.markersDescriptions.forEach((String markerID, Map markerData) {
      LatLng markerPos = LatLng(markerData['position_x'], markerData['position_y']);
      double range = markerData['range'];

      // check if marker should be activated
      getDistanceBetweenPositions(user, markerPos).then((distance){
        if( distance < range ){ activated.add(markerID); }
      });
    });
    return activated;
  }

  // ===========================================================================
  Future<void> operatePositionChange({Position position}) async {

    // get activated markers
    _activatedNow = getActivatedMarkers(position.toLatLng());

    // TODO remove markers from previous tick that are not active
    // _activatedPreviously.removeWhere((item) => !_activatedNow.contains(item));

    // TODO list of activated markers is delayed
    print("activated now: $_activatedNow");
    print("activated previously: $_activatedPreviously");

    for (String markerId in _activatedNow) {
      // if marker has not been activated earlier
      if(!_activatedPreviously.contains(markerId)){

        // TODO activate marker actions
        print("activated actions:");
        print(_markerLoader.getMarkerActions(id: markerId));

        _showNotificationWithDefaultSound(
            title: "POSITION CHANGE DETECTED",
            content: "CITIZEN NR 26108, STAY AT HOME"
        );

        // add marker to previously activated list
        _activatedPreviously.add(markerId);
      }
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
    await _flutterLocalNotificationsPlugin.show(
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