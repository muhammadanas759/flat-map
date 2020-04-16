import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:async';


class MarkerLoader {
  // ===========================================================================
  //-------------------------- VARIABLES ---------------------------------------
  // server address - TODO add server address
  String _serverURL = "";

  // list of marker data in strings
  Map<String, Map> markersDescriptions = <String, Map>{};

  // google maps markers set
  Map<String, Marker> googleMarkers = <String, Marker>{};

  // zones set
  Map<String, Circle> zones  = <String, Circle>{};

  // icons loader
  final IconsLoader iconsLoader = IconsLoader();

  // ===========================================================================
  //-------------------------- LOADING METHODS ---------------------------------
  // constructor
//  MarkerLoader() {
//    loadMarkers();
//  }

  // load markers from local storage
  Future loadMarkers() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/marker_storage.json';
    // if marker storage does exist

    if (await File(path).exists()){
      // get storage content
      final file = File(path);
      String markerStorage = await file.readAsString();
      // save it to map
      try{
        markersDescriptions = Map<String, Map<dynamic, dynamic>>.from(
            json.decode(markerStorage)
        );
      } catch (error) {
        print(error);
        print('could not load marker descriptions from local storage...');

        // clear file
        File(path).writeAsString('');
      }
    } else {
      // create new one
      File(path).writeAsString('');
      print('local storage did not exist, created new one...');
    }

    _descriptionsToObjects();
  }

  // translate descriptions to google map markers and zones
  void _descriptionsToObjects(){
    // for each marker description
    markersDescriptions.forEach((String markerID, Map markerData) {

      String id = markerID;
      LatLng position = LatLng(
          markerData['position_x'],
          markerData['position_y']
      );

      // translate description into marker in markers set:
      // BitmapDescriptor icon = iconsLoader.getMarkerImage(markerMap['icon']);

      // add marker
      addMarker(
          id: id,
          position: position,
          icon: markerData['icon'],
          title: markerData['title'],
          description: markerData['description'],
          range: markerData['range']
      );
    });
  }

  // translate google map markers and zones to descriptions
  void _objectsToDescriptions(){
    // translate googleMarkers to markersDescription
    googleMarkers.forEach((String id, Marker marker) {
      markersDescriptions[id] = {
        'position_x': marker.position.latitude,
        'position_y': marker.position.longitude,
        'range': zones[id].radius,
        'icon': 'default', // TODO ???
        'title': marker.infoWindow.title,
        'description': marker.infoWindow.snippet,
      };
    });
  }

  String generateId(){
    return UniqueKey().toString();
  }

  void addMarker({
    String id, LatLng position, String icon,
    String title, String description, double range
  }){
    googleMarkers[id] = Marker(
      markerId: MarkerId(id),
      position: position,
      // icon: icon,
      //      onTap: () {},
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
    );

    // save descriptions
    _objectsToDescriptions();
  }

  void removeMarker({String id}){
    markersDescriptions.remove(id);
    googleMarkers.remove(id);
    zones.remove(id);
  }

  // TODO edit marker
  void editMarker(){

  }

  // save markers to local storage
  void saveMarkers() async {

    // populate description with markers
    _objectsToDescriptions();

    // save markersDescription
    final directory = await getApplicationDocumentsDirectory();
    final file = new File('${directory.path}/marker_storage.json');
    String markerStorage = json.encode(markersDescriptions);
    await file.writeAsString(markerStorage);
  }
  
  Future<Marker> temporaryMarker(LatLng position) async {
    return Marker(
        markerId: MarkerId("temporary"),
        position: position,
        infoWindow: InfoWindow(
          title: "temporary marker",
          snippet: "marker presenting chosen position",
        )
    );
  }

  // ===========================================================================
  //-------------------------- NETWORK CONTENT ---------------------------------
  Future<http.Response> postMarkers({
    String endpoint, Map<String, Map> content
  }) async {
    http.Response _response;
    _response = await http.post(
        _serverURL + "/$endpoint",
        headers: {"Content-type": "application/json"},
        body: json.encode(content)
    );

    return _response;
  }

  // TODO add all endpoints from docs
  Future<Map<String, Map<dynamic, dynamic>>> getMarkers({String endpoint}) async {
    http.Response _response;
    _response = await http.get(
        _serverURL + "/$endpoint",
        headers: {"Content-type": "application/json"},
    );

    return json.decode(_response.body);
  }

  void internetTest() async {
    if(markersDescriptions == null){
      await loadMarkers();
    }

    // post markers
    await postMarkers(endpoint: "marker", content: markersDescriptions);

    // get markers
    Map<String, Map<dynamic, dynamic>> temp = await getMarkers(endpoint: "marker");

    // analyse results
    temp.forEach((String element, Map marker) => print(element));
  }
}
