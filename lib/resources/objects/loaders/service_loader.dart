import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ServiceLoader{
  static void startServiceInPlatform() async{
    if(Platform.isAndroid)
      {
        var methodChannel = MethodChannel("com.flatmapp.messeges");
        String data = await methodChannel.invokeMethod("startService");
        debugPrint(data);
      }
  }

  static void stopServiceInPlatform() async{
    if(Platform.isAndroid)
    {
      var methodChannel = MethodChannel("com.flatmapp.messeges");
      String data = await methodChannel.invokeMethod("stopService");
      debugPrint(data);
    }
  }


}