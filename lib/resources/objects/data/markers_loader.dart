import 'dart:convert';
import 'dart:io';

import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/map/utils/map_marker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class MarkerLoader {
  // server address - TODO add server address
  String _serverURL = "";

  // list of marker data in strings
  List<dynamic> _markersDescriptions = [];

  // custom markers set
  final Set<MapMarker> _mapMarkers = Set();

  // google maps markers set
  final Set<Marker> googleMarkers = Set();

  // zones set - TODO zones repair
  Set<Circle> zones = Set.from([
    Circle(
      circleId: CircleId('1'),
      center: LatLng(52.466684, 16.926901),
      radius: 30,
    ),
  ]);

  // icons loader
  final IconsLoader _iconsLoader = IconsLoader();

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

    // load icons
    // await _iconsLoader.loadingAllIcons(); - suppressed due to individual load

    // for each marker description in json
    for (Map markerMap in _markersDescriptions) {

      // translate description into marker in markers set:
      _iconsLoader.getMarkerImage(markerMap['icon']).then((value) {
        _mapMarkers.add(
          MapMarker(
              id: markerMap['id'].toString(),
              title: markerMap['title'],
              position: LatLng(
                  markerMap['position_x'],
                  markerMap['position_y']
              ),
              description: markerMap['description'],
              range: markerMap['range'],
              icon: value
          ),
        );
      });
    }

    // for map marker object in set
    for (MapMarker mapMarker in _mapMarkers) {
      // translate map marker into google marker:
      googleMarkers.add(
          mapMarker.toMarker()
      );
    }
  }

  // save markers to local storage
  void saveMarkers() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = new File('${directory.path}/marker_storage.json');
    String markerStorage = json.encode(_markersDescriptions);
    await file.writeAsString(markerStorage);
  }

  // add marker
  void addMarker() {

  }

  void changeMarker({int id}){

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