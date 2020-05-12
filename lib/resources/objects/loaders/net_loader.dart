import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:global_configuration/global_configuration.dart';
import 'package:preferences/preference_service.dart';


// https://pub.dev/packages/global_configuration
class NetLoader {

  String _serverURL = "http://64.227.122.119:8000";

  Future<http.Response> postForToken({
    String endpoint, Map<String, dynamic> content
  }) async {
    http.Response _response;
    _response = await http.post(
      _serverURL + "$endpoint",
      headers: {"Content-type": "application/json"},
      body: json.encode(content)
    );
    return _response;
  }

  // TODO add all endpoints from docs
  //Method for getting user backed up markers from server
  Future<http.Response> getMarkers({String endpoint}) async {
    http.Response _response;
    _response = await http.get(
      _serverURL + "/$endpoint",
      headers: {"Content-type": "application/json",
        HttpHeaders.authorizationHeader : "Token " + PrefService.getString("token")},
    );
    return _response;
  }

  Future<http.Response> postMarkers({
    String endpoint, Map<String, dynamic> content
  }) async {
    http.Response _response;
    _response = await http.post(
        _serverURL + "$endpoint",
        headers: {"Content-type": "application/json",
          HttpHeaders.authorizationHeader : "Token " + PrefService.getString("token")},
        body: json.encode(content)
    );
    return _response;
  }
}

