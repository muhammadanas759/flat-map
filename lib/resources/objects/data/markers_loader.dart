import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flatmapp/resources/objects/data/icons_loader.dart';


class MarkerLoader {
  //-------------------------- VARIABLES ---------------------------------------
  // server address - TODO add server address
  String _serverURL = "";

  // list of marker data in strings
  List<dynamic> _markersDescriptions = [];

  // google maps markers set
  Map<String, Marker> googleMarkers = <String, Marker>{};

  // zones set
  Map<String, Circle> zones  = <String, Circle>{};

  // icons loader
  final IconsLoader _iconsLoader = IconsLoader();

  //-------------------------- LOADING METHODS ---------------------------------
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
      _markersDescriptions = json.decode(markerStorage);

    } else {
      // create new one
      File(path).writeAsString('[]');
    }

    // for each marker description in json
    for (Map markerMap in _markersDescriptions) {

      String id = markerMap['id'];
      LatLng position = LatLng(
          markerMap['position_x'],
          markerMap['position_y']
      );

      // translate description into marker in markers set:
      BitmapDescriptor icon = _iconsLoader.getMarkerImage(markerMap['icon']);
      googleMarkers[id] = Marker(
        markerId: MarkerId(id),
        position: position,
        icon: icon,
//      onTap: () {},
        infoWindow: InfoWindow(
          title: markerMap['title'],
          snippet: markerMap['description'],
        )
      );

      // add zone
      zones[id] = Circle(
        circleId: CircleId(id),
        center: position,
        radius: markerMap['range'],
      );
    }
  }

  // TODO generate id
  String generateId(){
    return "id_1";
  }

  // save markers to local storage
  void saveMarkers() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = new File('${directory.path}/marker_storage.json');
    String markerStorage = json.encode(_markersDescriptions);
    await file.writeAsString(markerStorage);
  }
  
  Future<Marker> temporaryMarker(LatLng position) async {
    BitmapDescriptor icon = _iconsLoader.getMarkerImage(
        "home",
        targetWidth: 80
    );
    return Marker(
        markerId: MarkerId("temporary"),
        position: position,
        icon: icon,
        infoWindow: InfoWindow(
          title: "temporary marker",
          snippet: "marker presenting chosen position",
        )
    );
  }

  //-------------------------- NETWORK CONTENT ---------------------------------
  Future<http.Response> postMarkers({String endpoint, List<dynamic> content}) async {
    http.Response _response;
    _response = await http.post(
        _serverURL + "/$endpoint",
        headers: {"Content-type": "application/json"},
        body: json.encode(content)
    );

    return _response;
  }

  // TODO add all endpoints from docs
  Future<List<dynamic>> getMarkers({String endpoint}) async {
    http.Response _response;
    _response = await http.get(
        _serverURL + "/$endpoint",
        headers: {"Content-type": "application/json"},
    );

    return json.decode(_response.body);
  }

  void internetTest() async {
    if(_markersDescriptions == null){
      await loadMarkers();
    }

    // post markers
    await postMarkers(endpoint: "marker", content: _markersDescriptions);

    // get markers
    List<dynamic> temp = await getMarkers(endpoint: "marker");

    // analyse results
    temp.forEach((element) => print(element));
  }
}