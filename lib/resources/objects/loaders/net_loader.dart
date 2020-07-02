import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/models/flatmapp_action.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:preferences/preferences.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';



class NetLoader {

  String _serverURL = GlobalConfiguration().getString("server_url");

  void showToast(String message){
    print(message); // TODO REMOVE TEST
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void analyseResponse(http.Response response){
    if(response.statusCode >= 300){
      print(response.statusCode);
      throw HttpException(response.body);
    }
    // verify if response can be parsed
    try {
      var decoded = json.decode(response.body);
      if(!(decoded is Map) && !(decoded is List)){
        throw Exception("Can not decode response body to correct JSON\n\n" + response.body);
      }
    } on FormatException catch(e){
      print("Format exception error\n$e");
      print("Response body: ${response.body}");
    }
  }

  Future<http.Response> _postToServer({String endpoint, List<Map<String, dynamic>> content}) async {
    String _token = PrefService.getString('token');
    http.Response _response = await http.post(
      _serverURL + endpoint,
      headers: {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: "Token $_token",
      },
      body: json.encode(content)
      // body:
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

  Future<http.Response> _putToServer({
    String endpoint, Map<String, dynamic> content
  }) async {
    String _token = PrefService.getString('token');
    http.Response _response = await http.put(
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

  Future<http.Response> _putToServer2({
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

  Future<List<dynamic>> _getFromServer({String endpoint}) async {
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
    return List<dynamic>.from(json.decode(_response.body));
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
  Future<http.Response> getToken({
    String endpoint, Map<String, dynamic> content }) async {
    http.Response _response;
    try {
      _response = await http.post(
          _serverURL + endpoint,
          headers: {
            "Content-type": "application/json",
          },
          body: json.encode(content)
      );
      // verify response
      analyseResponse(_response);
    } on SocketException catch (e) {
      print(e);
      showToast("Error: request timed out");
    } on HttpException catch (e) {
      print(e);
      showToast("Error: Unable to log in with provided credentials.");
    }
    return _response;
  }

  Future<void> postBackup(BuildContext context, MarkerLoader markerLoader) async {
    if(PrefService.get("cloud_enabled") == true) {
      try {

        List<Map<String, dynamic>> parsedMarkers = [];

        // parse markers to form acceptable in server interface
        markerLoader.getMarkersDescriptions().forEach((key, value) {
          // TODO can not store temporary marker in backup due to the:
          // empty title
          // empty name
          // permanent id (temporary) equal for all users
          // impossibility of recovering temporary data -
          // it is indistinguishable from other markers
          if(key != "temporary"){
            parsedMarkers.add({
              "Action_Name": value.actions,
              "position_x": value.position_x,
              "position_y": value.position_y,
              "_range": value.range,
              // TODO determine what action_position means
              // "action_position": value.action_position,
              "title": value.title,
              "icon": value.icon,
              "description": value.description,
              // TODO determine what action_detail means
              // "action_detail": "none",
            });
          }
        });

        // TODO repair this on server side - backups are not overwritten and have to be deleted first
        // removeBackup();

        // send parsed markers
        await _postToServer(
          endpoint: "/api/backup/",
          content: parsedMarkers,
        );

        showToast("Backup uploaded successfully");
      } on SocketException catch (e) {
        print(e);
        showToast("Error: request timed out");
      } on HttpException catch (e) {
        print(e);
        showToast("Error: server could not process backup");
      }
    } else {
      showToast("Cloud save is not enabled in Settings - advanced");
    }
  }

  // parse list from backup to marker actions list
  List<FlatMappAction> toActionsList(List<dynamic> actionsList){
    List<FlatMappAction> result = [];
    actionsList.forEach((element) {
      try{
        if(element != null){
          result.add(
            FlatMappAction.fromJson(element)
          );
        } else {
          print("action is null");
        }
      } on Exception catch(e){
        print("action parsing error:\n$e");
      }
    });
    return result;
  }

  // odczyt znaczników z bazy
  Future<void> getBackup(BuildContext context, MarkerLoader markerLoader) async {
    if(PrefService.get("cloud_enabled") == true){
      try{

        List<dynamic> parsedMarkers = await _getFromServer(
          endpoint: "/api/backup/",
        );

        // remove markers from local storage
        markerLoader.removeAllMarkers();
        print("akcje:");
        parsedMarkers.forEach((marker) {
          markerLoader.addMarker(
            id: markerLoader.generateId(),
            position: LatLng(marker['position_x'], marker['position_y']),
            icon: marker['icon'].toString(),
            title: marker['title'].toString(),
            description: marker['description'].toString(),
            range: marker['_range'],
            actions: toActionsList(List<dynamic>.from(marker['Action_Name'])),
          );
          print(marker['Action_Name']);
        });



        if(parsedMarkers.isEmpty){
          showToast("Backup is empty");
        } else {

          // save backup to file
          markerLoader.saveMarkers();

          // reset focused marker
          PrefService.setString("selected_marker", 'temporary');

          showToast("Backup downloaded successfully");
        }
      } on SocketException catch (e) {
        print(e);
        showToast("Error: request timed out");
    } on HttpException catch (e) {
        print(e);
        showToast("Error: server could not process backup");
      } on Exception catch (e) {
        print(e);
        showToast("Error: something went wrong during download");
      }
    } else {
      showToast("Cloud save is not enabled in Settings - advanced");
    }
  }

  Future<http.Response> changePassword(Map<String, dynamic> content) async {
    try{
      return await _putToServer(
        endpoint: "/api/account/change_password/",
        content: content,
      );
    } on HttpException catch (e) {
      print(e);
      showToast("Error: server could not process data");
      return http.Response("", 300);
    } on Exception catch (e) {
      print(e);
      showToast("Error: something went wrong");
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
      showToast("Error: server could not process data");
      return http.Response("", 300);
    } on Exception catch (e) {
      print(e);
      showToast("Error: something went wrong");
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
      showToast("Error: server could not process data");
      return http.Response("", 300);
    } on Exception catch (e) {
      print(e);
      showToast("Error: something went wrong");
      return http.Response("", 300);
    }
  }

  Future<http.Response> register(Map<String, dynamic> content) async {
    try{
      // register endpoint
      return await _putToServer2(
        endpoint: "/api/account/register/",
        content: content,
      );
    } on HttpException catch (e) {
      print(e);
      showToast("Error: server could not process data");
      return http.Response("", 300);
    } on Exception catch (e) {
      print(e);
      showToast("Error: something went wrong");
      return http.Response("", 300);
    }
  }

  void sendFile(String filepath, String endpoint) {
    // https://dev.to/carminezacc/advanced-flutter-networking-part-1-uploading-a-file-to-a-rest-api-from-flutter-using-a-multi-part-form-data-post-request-2ekm
    // init request
    var request = new http.MultipartRequest(
      "POST",
      Uri.parse(_serverURL + endpoint)
    );

    // add file to request
    http.MultipartFile.fromPath(
      'backup',
      filepath
    ).then((file){request.files.add(file);});

    // send request
    request.send().then((response) {
      if (response.statusCode/100 == 2){
        print("Uploaded!");
      }else{
        print(response.statusCode);
        print("something went wrong during upload");
      }
    });
  }
}
