import 'package:flatmapp/resources/objects/loaders/icons_loader.dart';
import 'package:flatmapp/resources/objects/models/action.dart';
import 'package:flatmapp/resources/objects/models/flatmapp_marker.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:preferences/preferences.dart';


class MarkerLoader {
  // ===========================================================================
  //-------------------------- VARIABLES ---------------------------------------

  // list of marker data in strings
  Map<String, FlatMappMarker> _markersDescriptions = <String, FlatMappMarker>{};

  // google maps markers set
  Map<String, Marker> googleMarkers = <String, Marker>{};

  // zones set
  Map<String, Circle> zones  = <String, Circle>{};

  // time of last modification
  DateTime _markersLastModification = DateTime.now();

  // icons loader
  final IconsLoader iconsLoader = IconsLoader();

  final _firstCoordinates = LatLng(52.466791, 16.926939);

  // ===========================================================================
  //-------------------------- LOADING METHODS ---------------------------------

  Future<String> getFilePath() async {
    // get file storage path
    try {
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/marker_storage.json';
    } on FileSystemException catch (e) {
      // file error
      print('File processing error: $e');
      return '';
    }
  }

  Future updateMarkersOnFileChange() async{
    String path = await getFilePath();
    try {
      if (File(path).lastModifiedSync().isAfter(_markersLastModification)) {
        _markersLastModification = File(path).lastModifiedSync();
        this.loadMarkers();
      }
    } on FileSystemException catch(e) {
      print(e);
    }
  }

  void _repairFile(String path){
    // clear file
    File(path).writeAsString('');
    // add temporary marker
    addTemporaryMarker(_firstCoordinates);
  }

  // save markers to local storage
  void saveMarkers() async {

    // save markersDescription
    final path_ = await getFilePath();
    final file = new File(path_);
    String markerStorage = json.encode(_markersDescriptions);
    await file.writeAsString(markerStorage);
  }

  // load markers from local storage
  Future loadMarkers() async {
    String path = await getFilePath();

    // if marker storage does exist
    if (await File(path).exists()){

      // get storage content
      final file = File(path);
      String markerStorage = await file.readAsString();

      try{
//        save it to map: throws
//        type '_InternalLinkedHashMap<String, dynamic>'
//        is not a subtype of type 'FlatMappMarker'.
//        Requires cast method override in FlatMappMarker from _InternalLinkedHashMap<String, dynamic>.
//        _markersDescriptions = Map<String, FlatMappMarker>.from(
//            json.decode(markerStorage)
//        );

        Map<String, dynamic> jsonObj = json.decode(markerStorage);
        jsonObj.forEach((key, value) {
          _markersDescriptions[key] = FlatMappMarker.fromJson(value);
        });

      } catch (error) {
        print(error);
        print('could not load marker descriptions from local storage...');

        _repairFile(path);
      }
    } else {
      _repairFile(path);
      print('local storage did not exist, created new one...');
    }

    _descriptionsToObjects();
  }

  // translate descriptions to google map markers and zones
  void _descriptionsToObjects(){
    // for each marker description
    _markersDescriptions.forEach((String markerID, FlatMappMarker markerData) {

      String id = markerID;
      LatLng position = LatLng(
          markerData.position_x,
          markerData.position_y
      );

      // add marker
      addMarker(
          id: id,
          position: position,
          icon: markerData.icon,
          title: markerData.title,
          description: markerData.description,
          range: markerData.range,
          actions: markerData.actions,
      );
    });
  }

  // generate unique id for markers
  String generateId(){
    return UniqueKey().toString();
  }

  // add or edit marker
  void addMarker({
    String id, LatLng position, String icon,
    String title, String description, double range, List<FlatMappAction> actions
  }){

    _markersDescriptions[id] = FlatMappMarker(
      position.latitude,
      position.longitude,
      range,
      -420,
      title,
      description,
      icon,
      actions
    );

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
  void saveMarkersFromBackup({Map<String, FlatMappMarker> content}) async {
    _markersDescriptions = content;
    saveMarkers();
  }
  
  void addTemporaryMarker(LatLng position){
    addMarker(
      id: "temporary",
      position: position,
      icon: 'default',
      title: "",
      description: "",
      range: 10,
      actions: [],
    );
  }

  FlatMappMarker getMarkerDescription({String id}){
    if(_markersDescriptions[id] == null){
      getFilePath().then((path){_repairFile(path);});
    }
    return _markersDescriptions[id];
  }

  Map<String, FlatMappMarker> getMarkersDescriptions(){
    return _markersDescriptions;
  }

  Marker getGoogleMarker({String id}){
    return googleMarkers[id];
  }

  List<String> getDescriptionsKeys(){
    return _markersDescriptions.keys.toList();
  }

  double getRange({String id}){
    return zones[id].radius;
  }

  List<dynamic> getMarkerActions({String id}){
    return _markersDescriptions[id].actions;
  }

  void addMarkerAction({String id, FlatMappAction action}) {
    if(_markersDescriptions[id].actions == null){
      _markersDescriptions[id].actions = [];
    }

    // update action position
    action.action_position = (_markersDescriptions[id].actions.length + 1).toDouble();

    _markersDescriptions[id].actions.add(action);
    saveMarkers();
  }

  void removeMarkerAction({String id, int index}) {
    if(_markersDescriptions[id].actions[index] != null){
      _markersDescriptions[id].actions.removeAt(index);
    } else {
      print("no action to remove at index $index from marker $id");
    }
  }

  Future<void> removeAllMarkers() async {
    // from non-persistent storage
    _markersDescriptions.clear();
    googleMarkers.clear();
    zones.clear();

    // from persistent storage
    String path = await getFilePath();
    // if marker storage does exist
    if (await File(path).exists()){
      // create new one
      File(path).writeAsString('');
      // add temporary marker
      addTemporaryMarker(_firstCoordinates);
    }
  }
}
