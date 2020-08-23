import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class GeofenceLoader{
  static void addGeofence(String marker) async{
    if(Platform.isAndroid)
      {
        var methodChannel = MethodChannel("com.flatmapp.messeges");
        String data = await methodChannel.invokeMethod("addMarker", {"marker" : marker});
        debugPrint(data);
      }
  }

  static void deleteGeofence(String markers) async{
    if(Platform.isAndroid)
    {
      var methodChannel = MethodChannel("com.flatmapp.messeges");
      String data = await methodChannel.invokeMethod("deleteMarkers", {"markers" : markers});
      debugPrint(data);
    }
  }


}