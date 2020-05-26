import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  Future<http.Response> _postToServer({
    String endpoint, List<Map<String, dynamic>> content
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

  Future<http.Response> _patchToServer({
    String endpoint, Map<String, dynamic> content
  }) async {

    String _token = PrefService.getString('token');

    http.Response _response = await http.patch(
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

  Future<List<Map<String, dynamic>>> _getFromServer({String endpoint}) async {

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

  Future<http.Response> _deleteToServer({String endpoint}) async {

    String _token = PrefService.getString('token');

    http.Response _response = await http.delete(
      _serverURL + endpoint,
      headers: {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: "Token $_token",
      },
    );

    // verify response
    analyseResponse(_response);

    return _response;
  }


  // ------------------------------------------------------------------------
  // TODO zapis znaczników do bazy
  Future<void> postBackup(BuildContext context, MarkerLoader markerLoader) async {
    if(PrefService.get("cloud_enabled") == true) {
      try {

        List<Map<String, dynamic>> parsedMarkers = [];

        // parse markers to form acceptable in server interface
        markerLoader.getMarkersDescriptions().forEach((key, value) {
          parsedMarkers.add({
            "Action_Name": value.actions,
            "position_x": value.position_x,
            "position_y": value.position_y,
            "_range": value.range,
            // TODO determine what action_position means
            "action_position": value.action_position,
            "title": value.title,
            "icon": value.icon,
            "description": value.description,
            // TODO determine what action_detail means
            "action_detail": "",
          });
        });

        // send parsed markers
        print("SENDING BACKUP ----------------------"); // TODO remove print

        await _postToServer(
          endpoint: "/api/backup/",
          content: parsedMarkers,
        );

        print("Backup uploaded successfully"); // TODO remove print

        Fluttertoast.showToast(
          msg: "Backup uploaded successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } on SocketException catch (e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Error: request timed out",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } on HttpException catch (e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Error: server could not process backup",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Cloud save is not enabled in Settings - advanced",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // TODO odczyt znaczników z bazy
  Future<void> getBackup(BuildContext context, MarkerLoader markerLoader) async {
    if(PrefService.get("cloud_enabled") == true){
      try{
        print("DOWNLOADING BACKUP ----------------------"); // TODO remove print

        List<Map<String, dynamic>> parsedMarkers = await _getFromServer(
          endpoint: "/api/backup/",
        );

        // TODO unlock in final version
        // markerLoader.removeAllMarkers();

        parsedMarkers.forEach((marker) {
          markerLoader.addMarker(
            id: markerLoader.generateId(),
            position: LatLng(marker['position_x'], marker['position_y']),
            icon: marker['icon'],
            title: marker['title'],
            description: marker['description'],
            range: marker['range'],
            actions: marker['Action_Name'],
          );
        });

        print("Backup downloaded successfully"); // TODO remove print

        Fluttertoast.showToast(
          msg: "Backup downloaded successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } on SocketException catch (e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Error: request timed out",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
    } on HttpException catch (e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Error: server could not process backup",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      } on Exception catch (e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Error: something went wrong during download",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Cloud save is not enabled in Settings - advanced",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<http.Response> changePassword(Map<String, dynamic> content) async {
    try{
      return await _patchToServer(
        endpoint: "/api/account/login",
        content: content,
      );

    } on HttpException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error: server could not process data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return http.Response("", 300);
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error: something went wrong",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return http.Response("", 300);
    }
  }

  Future<http.Response> removeAccount() async {
    try{
      return await _deleteToServer(
        endpoint: "/api/account/",
      );
    } on HttpException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error: server could not process data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return http.Response("", 300);
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error: something went wrong",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return http.Response("", 300);
    }
  }

  Future<http.Response> removeBackup() async {
    try{
      return await _deleteToServer(
        endpoint: "/api/backup/",
      );
    } on HttpException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error: server could not process data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return http.Response("", 300);
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Error: something went wrong",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return http.Response("", 300);
    }
  }
}
