import 'package:flutter_test/flutter_test.dart';
import 'package:preferences/preference_service.dart';
import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';


Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  String _serverURL = GlobalConfiguration().getString("server_url");
  group('net_loader', () {
    test('Loging in to existing account with correct credentials', () async {
      NetLoader netLoader = NetLoader();

      final Map<String, dynamic> _formData = {
        'username': 'a@a.pl',
        'password': 'Testowehaslo1!',
      };

      http.Response _response = await netLoader.getToken(endpoint: '/api/account/login/', content: _formData);
      String _token = json.decode(_response.body)["token"].toString();

      expect(_token, isNot("null"));
    });
  });
}