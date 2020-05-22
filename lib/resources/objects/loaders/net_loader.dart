import 'dart:convert';
import 'dart:io';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:http/http.dart' as http;

import 'package:global_configuration/global_configuration.dart';
import 'package:preferences/preferences.dart';


class NetLoader {

  String _serverURL = GlobalConfiguration().getString("server_url");

  void analyseResponse(http.Response response){
    if(response.statusCode >= 300){
      throw HttpException(response.body);
    }
    // verify if response can be parsed
    if(!(json.decode(response.body) is Map)){
      throw Exception("Can not decode response body to correct JSON\n\n" + response.body);
    }
  }

  Future<http.Response> postToServer({
    String endpoint, Map<String, dynamic> content
  }) async {

    String _token = PrefService.getString('token');

    http.Response _response = await http.post(
      _serverURL + endpoint,
      headers: {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: "Token $_token",
      },
      body: json.encode(content)
    );

    // verify response
    analyseResponse(_response);

    return _response;
  }

  Future<http.Response> getToken({
    String endpoint, Map<String, dynamic> content
  }) async {

    http.Response _response = await http.post(
        _serverURL + endpoint,
        headers: {
          "Content-type": "application/json",
        },
        body: json.encode(content)
    );

    // verify response
    analyseResponse(_response);

    return _response;
  }

  Future<Map<String, Map<dynamic, dynamic>>> getFromServer({String endpoint}) async {

    String _token = PrefService.getString('token');

    http.Response _response = await http.get(
      _serverURL + endpoint,
      headers: {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: "Token $_token",
      },
    );

    // verify response
    analyseResponse(_response);

    return json.decode(_response.body);
  }

  // ------------------------------------------------------------------------

  // TODO zapis znaczników do bazy
  Future<void> postBackup(MarkerLoader markerLoader) async {
    if(PrefService.get("cloud_enabled") == true) {
      try {
        await postToServer(
          endpoint: "/api/backup/trigger/",
          content: markerLoader.getMarkersDescriptions(),
        );
      } on HttpException catch (e) {
        print(e);
      }
    } else {
      print("cloud save is not enabled");
    }
  }

  // TODO odczyt znaczników z bazy
  Future<void> getBackup(MarkerLoader markerLoader) async {
    if(PrefService.get("cloud_enabled") == true){
      try{
        Map<String, Map> _markersDescriptions = await getFromServer(
          endpoint: "/api/backup/trigger/",
        );

        _markersDescriptions.forEach((key, value) {
          print(value);
        });

        markerLoader.saveMarkersFromBackup(content: _markersDescriptions);
      } on HttpException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    } else {
      print("cloud save is not enabled");
    }
  }

  // TODO zmiana hasła
  Future<http.Response> changePassword(Map<String, dynamic> content) async {
    return null;
  }
}