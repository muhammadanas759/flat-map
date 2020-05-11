import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/data/net_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:preferences/preferences.dart';


class MarkerLoader {
  // ===========================================================================
  //-------------------------- VARIABLES ---------------------------------------

  // list of marker data in strings
  Map<String, Map> _markersDescriptions = <String, Map>{};

  // google maps markers set
  Map<String, Marker> googleMarkers = <String, Marker>{};

  // zones set
  Map<String, Circle> zones  = <String, Circle>{};

  // icons loader
  final IconsLoader iconsLoader = IconsLoader();

  // internet connection gateway object
  // ignore: unused_field
  final NetLoader _netLoader = NetLoader();

  // ===========================================================================
  //-------------------------- LOADING METHODS ---------------------------------

  Future<String> getFilePath() async {
    // get file storage path
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/marker_storage.json';
  }

  // load markers from local storage
  Future loadMarkers() async {
    String path = await getFilePath();
    // if marker storage does exist

    if (await File(path).exists()){
      // get storage content
      final file = File(path);
      String markerStorage = await file.readAsString();
      // save it to map
      try{
        _markersDescriptions = Map<String, Map<dynamic, dynamic>>.from(
            json.decode(markerStorage)
        );
      } catch (error) {
        print(error);
        print('could not load marker descriptions from local storage...');

        // clear file
        File(path).writeAsString('');
        // add temporary marker
        addTemporaryMarker(LatLng(69.420, 69.420));
      }
    } else {
      // create new one
      File(path).writeAsString('');
      // add temporary marker
      addTemporaryMarker(LatLng(69.420, 69.420));
      print('local storage did not exist, created new one...');
    }

    _descriptionsToObjects();
  }

  // translate descriptions to google map markers and zones
  void _descriptionsToObjects(){
    // for each marker description
    _markersDescriptions.forEach((String markerID, Map markerData) {

      String id = markerID;
      LatLng position = LatLng(
          markerData['position_x'],
          markerData['position_y']
      );

      // add marker
      addMarker(
          id: id,
          position: position,
          icon: markerData['icon'],
          title: markerData['title'],
          description: markerData['description'],
          range: markerData['range'],
          actions: markerData['actions'],
      );
    });
  }

  String generateId(){
    return UniqueKey().toString();
  }

  // add or edit marker
  void addMarker({
    String id, LatLng position, String icon,
    String title, String description, double range, List<dynamic> actions
  }){

    _markersDescriptions[id] = {
      'position_x': position.latitude,
      'position_y': position.longitude,
      'range': range,
      'icon': icon,
      'title': title,
      'description': description,
      'actions': actions,
    };

    iconsLoader.getMarkerImage(icon).then((iconBitmap){
      googleMarkers[id] = Marker(
          markerId: MarkerId(id),
          position: position,
          icon: iconBitmap,
          onTap: () {
            // set marker as selected on tap
            PrefService.setString('selected_marker', id);
            PrefService.setString('selected_icon', icon);
          },
          infoWindow: InfoWindow(
            title: title,
            snippet: description,
          )
      );

      // add zone
      zones[id] = Circle(
        circleId: CircleId(id),
        center: position,
        radius: range,
        fillColor: Colors.redAccent.withOpacity(0.2),
        strokeWidth: 2,
        strokeColor: Colors.redAccent,
      );
    });
  }

  void removeMarker({String id}){
    _markersDescriptions.remove(id);
    googleMarkers.remove(id);
    zones.remove(id);

    if(PrefService.get('selected_marker') == id){
      PrefService.setString('selected_marker', 'temporary');
    }
  }

  // save markers to local storage
  void saveMarkers() async {

    // save markersDescription
    final directory = await getApplicationDocumentsDirectory();
    final file = new File('${directory.path}/marker_storage.json');
    String markerStorage = json.encode(_markersDescriptions);
    await file.writeAsString(markerStorage);
  }
  
  void addTemporaryMarker(LatLng position){
    addMarker(
      id: "temporary",
      position: position,
      icon: 'default',
      title: "temporary marker",
      description: "marker presenting chosen position",
      range: 10,
      actions: [],
    );
  }

  Map<String, dynamic> getMarkerDescription({String id}){
    return Map<String, dynamic>.from(_markersDescriptions[id]);
  }

  Marker getGoogleMarker({String id}){
    return googleMarkers[id];
  }

  List<String> getDescriptionsKeys(){
    return _markersDescriptions.keys.toList();
  }

  int getRange({String id}){
    return zones[id].radius.toInt();
  }

  List<dynamic> getMarkerActions({String id}){
    return _markersDescriptions[id]['actions'];
  }

  void addMarkerAction({String id, String action}) {
    if(_markersDescriptions[id]['actions'] == null){
      _markersDescriptions[id]['actions'] = [];
    }
    _markersDescriptions[id]['actions'].add(action);
  }
}
