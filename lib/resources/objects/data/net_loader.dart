import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
// https://pub.dev/packages/global_configuration

class NetLoader
{
  String _serverURL = "http://64.227.122.119:8000";
  Future<http.Response> sendToServer({String endpoint, Map<String,
   dynamic> content}) async {
    http.Response _response;
    _response = await http.post(
        _serverURL + "$endpoint",
        headers: {"Content-type": "application/json"},
        body: json.encode(content)
    );
    return _response;
  }

}