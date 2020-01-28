import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class DataLoader{
  //------------------------------ INIT ----------------------------------------
  // NETWORK
  String _url = 'https://deadsmond.pythonanywhere.com/checkpoint';
  Map<String, String> _headers = {"Content-type": "application/json"};
  String _jsonBody = '{"data": "NULL"}';
  http.Response _response;

  // FILES
  String _data;

  //-------------------------- NETWORK CONTENT ---------------------------------
  void sendRequest() async {
    _response = await http.post(
        _url,
        headers: _headers,
        body: _jsonBody
    );
    print('Response status: ${_response.statusCode}');
    print('Response body: ${_response.body}');
  }

  //-------------------------- PERMISSION HANDLING -----------------------------
  Future<PermissionStatus> _getPermission(PermissionGroup permissionGroup) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(permissionGroup);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
      await PermissionHandler()
          .requestPermissions([permissionGroup]);
      return permissionStatus[permissionGroup] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  Future<bool> checkPermission(String type) async {
    try {
      PermissionGroup permission;
      if(type == "storage"){
        permission = PermissionGroup.storage;
      }else{
        throw FormatException("wrong value of type variable: $type");
      }
      PermissionStatus permissionStatus = await _getPermission(permission);
      if (permissionStatus == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    } catch (e){
      // what went wrong?
      throw(e);
    }
  }

  //-------------------------- FILES CONTENT -----------------------------------
  // TODO - there is a possibility, that only content loaded from file
  // TODO - will be settings.json. In that case, use global_configuration package
  // https://pub.dev/packages/global_configuration

  Future<File> getFile() async {
    String _path = '/storage/emulated/0/exported_data.txt';
    return File(_path);
  }

  void read() async {
    // check permission
    bool check = await checkPermission("storage");
    if (check) {
      // Read the file
      File _file = await getFile();
      _data = await _file.readAsString();
    }
  }

  void write() async {
    // Save to the file
    File _file = await getFile();
    _file.writeAsString(_data);
  }
}




