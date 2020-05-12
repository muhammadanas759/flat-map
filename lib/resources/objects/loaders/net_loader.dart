import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:global_configuration/global_configuration.dart';


// https://pub.dev/packages/global_configuration
class NetLoader {

  String _serverURL = "http://64.227.122.119:8000";

  Future<http.Response> postToServer({
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
  Future<Map<String, Map<dynamic, dynamic>>> getMarkers({String endpoint}) async {
    http.Response _response;
    _response = await http.get(
      _serverURL + "/$endpoint",
      headers: {"Content-type": "application/json"},
    );

    return json.decode(_response.body);
  }
}