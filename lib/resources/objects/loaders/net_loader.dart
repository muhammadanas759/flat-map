import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:global_configuration/global_configuration.dart';
import 'package:preferences/preferences.dart';


// https://pub.dev/packages/global_configuration
class NetLoader {

  String _serverURL = GlobalConfiguration().getString("server_url");

  Future<http.Response> postToServer({
    String endpoint, Map<String, dynamic> content
  }) async {

    String _token = PrefService.getString('token');

    http.Response _response;
    _response = await http.post(
      _serverURL + "$endpoint",
      headers: {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: "Token $_token",
      },
      body: json.encode(content)
    );
    return _response;
  }

  Future<http.Response> getToken({
    String endpoint, Map<String, dynamic> content
  }) async {

    http.Response _response;
    _response = await http.post(
        _serverURL + "$endpoint",
        headers: {
          "Content-type": "application/json",
        },
        body: json.encode(content)
    );
    return _response;
  }

  Future<Map<String, Map<dynamic, dynamic>>> getFromServer({String endpoint}) async {

    String _token = PrefService.getString('token');

    http.Response _response = await http.get(
      _serverURL + "/$endpoint",
      headers: {
        "Content-type": "application/json",
        HttpHeaders.authorizationHeader: "Token $_token",
      },
    );

    return json.decode(_response.body);
  }
}