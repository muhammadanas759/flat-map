import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


class MarkerLoader{
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
}