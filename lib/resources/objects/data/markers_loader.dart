import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class MarkerLoader {
  // server address - TODO add server address
  String _serverURL = "";

  // list of marker data
  List<dynamic> _markersMap;

  MarkerLoader(){
    loadMarkers();
  }

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
      _markersMap = json.decode(markerStorage);
    } else {
      // create new one
      File(path).writeAsString('[]');
      // default map
      _markersMap = [];
    }
  }

  // save markers to local storage
  void saveMarkers() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = new File('${directory.path}/marker_storage.json');
    String markerStorage = json.encode(_markersMap);
    await file.writeAsString(markerStorage);
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
    if(_markersMap == null){
      await loadMarkers();
    }

    // post markers
    await postMarkers(endpoint: "marker", content: _markersMap);

    // get markers
    List<dynamic> temp = await getMarkers(endpoint: "marker");

    // analyse results
    temp.forEach((element) => print(element));
  }
}