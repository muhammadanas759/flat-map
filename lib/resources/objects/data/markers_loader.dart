import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class MarkerLoader {
  // list of marker data
  List<dynamic> markersMap;

  Future loadMarkers() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/marker_storage.json';
    // if marker storage does exist
    if (await File(path).exists()){
      // get storage content
      final file = File(path);
      String markerStorage = await file.readAsString();
      // save it to map
      markersMap = json.decode(markerStorage);
    } else {
      // create new one
      File(path).writeAsString('[]');
      // default map
      markersMap = [];
    }
  }

  void saveMarkers() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = new File('${directory.path}/marker_storage.json');
    String markerStorage = json.encode(markersMap);
    await file.writeAsString(markerStorage);
  }

  //-------------------------- NETWORK CONTENT ---------------------------------
  void internetTest() async {
    if(markersMap == null){
      await loadMarkers();
    }

    List<dynamic> temp = await sendMarkers(markersMap);
    temp.forEach((element) => print(element));
  }

  Future<List<dynamic>> sendMarkers(List<dynamic> content) async {
    http.Response _response;
    _response = await http.post(
        'https://deadsmond.pythonanywhere.com/checkpoint',
        headers: {"Content-type": "application/json"},
        body: json.encode(content)
    );

    return json.decode(_response.body);
  }
}