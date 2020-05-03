import 'package:flatmapp/resources/routes/LogInRoute.dart';
import 'package:flatmapp/resources/routes/MapRoute.dart';
import 'package:flatmapp/resources/routes/ProfileRoute.dart';
import 'package:flatmapp/resources/routes/IconsRoute.dart';
import 'package:flatmapp/resources/routes/CommunityRoute.dart';
import 'package:flatmapp/resources/routes/SettingsRoute.dart';
import 'package:flatmapp/resources/routes/AboutRoute.dart';

import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/data/trigger_loader.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';


// create a new IsolateHandler instance used to spawn isolates.
// final isolates = IsolateHandler();

// store channels in a top-level Map for convenience
const Map<String, MethodChannel> channels = {
  'trigger': const MethodChannel('isolates.main/trigger'),
};

// geolocator API:
// https://pub.dev/documentation/geolocator/latest/geolocator/Geolocator-class.html
Geolocator _geolocator = Geolocator();

// notifications on location change
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// store chosen starting route
String initScreen;

// data loader
final MarkerLoader _markerLoader = MarkerLoader();

// TODO CHECK https://pub.dev/packages/flutter_isolate
// =============================================================================
// -------------------- TRIGGER ISOLATE SECTION --------------------------------

// This function happens in the isolate
void triggerEntryPoint(String arg) async {

  // initiate trigger loader in isolated process
  // ignore: unused_local_variable
  TriggerLoader _triggerLoader = TriggerLoader(
      _geolocator, flutterLocalNotificationsPlugin
  );
}

// =============================================================================
// ----------------------- MAIN PROCESS SECTION --------------------------------

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

  // TODO spawn isolated process for triggers

  // check permission
  _geolocator.checkGeolocationPermissionStatus().then((permission){
    // TODO check permission status
    if(permission != GeolocationStatus.granted){
      print("GEOLOCATION PERMISSION IS NOT GRANTED YET");
    }
    print(permission);
  });

  // init notifications
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS
  );
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(
      initializationSettings
  );

  // spawn isolated process with argument
  // ignore: unused_local_variable
  final isolate = await FlutterIsolate.spawn(triggerEntryPoint, "hello");

  runApp(MyApp());
}

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
