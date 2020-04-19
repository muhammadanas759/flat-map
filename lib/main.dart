import 'package:flatmapp/resources/routes/LogInRoute.dart';
import 'package:flatmapp/resources/routes/MapRoute.dart';
import 'package:flatmapp/resources/routes/ProfileRoute.dart';
import 'package:flatmapp/resources/routes/ActionsRoute.dart';
import 'package:flatmapp/resources/routes/CommunityRoute.dart';
import 'package:flatmapp/resources/routes/SettingsRoute.dart';
import 'package:flatmapp/resources/routes/AboutRoute.dart';

import 'package:flatmapp/resources/objects/data/markers_loader.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


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
    'selected_marker': null,
  });

  // get start page
  initScreen = PrefService.get('start_page');
  switch(initScreen) {
    case 'About': {initScreen = '/about';} break;
    case 'Actions': {initScreen = '/actions';} break;
    case 'Community': {initScreen = '/community';} break;
    case 'Log In': {initScreen = '/login';} break;
    case 'Map': {initScreen = '/map';} break;
    case 'Profile': {initScreen = '/profile';} break;
    case 'Settings': {initScreen = '/settings';} break;
    default: { throw Exception('wrong start_page value: $initScreen'); } break;
  }

  await _markerLoader.loadMarkers();

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
            '/actions': (context) => ActionsRoute(),
            '/community': (context) => CommunityRoute(),
            '/settings': (context) => SettingsRoute(),
            '/about': (context) => AboutRoute(),
            '/login': (context) => LogInRoute(),
          },
        );
      }
    );
  }
}
