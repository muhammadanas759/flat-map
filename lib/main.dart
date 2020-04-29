import 'package:flatmapp/resources/objects/data/trigger_loader.dart';
import 'package:flatmapp/resources/routes/LogInRoute.dart';
import 'package:flatmapp/resources/routes/MapRoute.dart';
import 'package:flatmapp/resources/routes/ProfileRoute.dart';
import 'package:flatmapp/resources/routes/IconsRoute.dart';
import 'package:flatmapp/resources/routes/CommunityRoute.dart';
import 'package:flatmapp/resources/routes/SettingsRoute.dart';
import 'package:flatmapp/resources/routes/AboutRoute.dart';

import 'package:flatmapp/resources/objects/data/markers_loader.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

// import 'dart:isolate';


String initScreen;

// data loader
final MarkerLoader _markerLoader = MarkerLoader();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');

  PrefService.setDefaultValues({
    'project_description': 'FlatMapp prototype',
    'start_page': 'Map',
    'ui_theme': 'light',
    'selected_marker': 'temporary',
    'selected_icon': 'default',
  });

  // get start page
  initScreen = PrefService.get('start_page');
  switch(initScreen) {
    case 'About': {initScreen = '/about';} break;
    case 'Community': {initScreen = '/community';} break;
    case 'Log In': {initScreen = '/login';} break;
    case 'Map': {initScreen = '/map';} break;
    case 'Profile': {initScreen = '/profile';} break;
    case 'Settings': {initScreen = '/settings';} break;
    default: { throw Exception('wrong start_page value: $initScreen'); } break;
  }

  await _markerLoader.loadMarkers();

//  // TODO spawn isolated process for triggers
//  var receivePort = new ReceivePort();
//  await Isolate.spawn(entryPoint, receivePort.sendPort);
//  // Receive the SendPort from the Isolate
//  SendPort sendPort = await receivePort.first;
//  // Send a message to the Isolate
//  sendPort.send("hello");

  runApp(MyApp());
}

// TODO BACKGROUND GEO https://medium.com/flutter/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124
// TODO CHECK https://pub.dev/packages/isolate_handler
// Entry point for your Isolate
//entryPoint(SendPort sendPort) async {
//  WidgetsFlutterBinding.ensureInitialized();
//  // Open the ReceivePort to listen for incoming messages (optional)
//  var port = new ReceivePort();
//  // trigger loader - must be implemented in Stateful widget
//  final TriggerLoader _triggerLoader = TriggerLoader();
//  // Send messages to other Isolates
//  sendPort.send(port.sendPort);
//  // Listen for messages (optional)
//  await for (var data in port) {
//    // `data` is the message received.
//  }
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
          brightness: brightness, accentColor: Colors.green),
      themedWidgetBuilder: (context, theme){
        return MaterialApp(
          title: 'FlatMApp',
          debugShowCheckedModeBanner: false,
          theme: theme,
          initialRoute: initScreen,
          routes: {
            // When navigating to the "/name" route, build the NameRoute widget.
            '/map': (context) => MapRoute(_markerLoader),
            '/profile': (context) => ProfileRoute(_markerLoader),
            '/community': (context) => CommunityRoute(),
            '/settings': (context) => SettingsRoute(),
            '/about': (context) => AboutRoute(),
            '/login': (context) => LogInRoute(),
            '/icons': (context) => IconsRoute(),
          },
        );
      }
    );
  }
}
