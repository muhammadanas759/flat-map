import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import './resources/routes/MapRoute.dart';
import './resources/routes/ProfileRoute.dart';
import './resources/routes/ActionsRoute.dart';
import './resources/routes/CommunityRoute.dart';
import './resources/routes/SettingsRoute.dart';
import './resources/routes/AboutRoute.dart';


String initScreen;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');

  PrefService.setDefaultValues({
    'project_description': 'FlatMapp prototype',
    'start_page': 'Map',
    'ui_theme': 'light',
  });

  // get start page
  initScreen = PrefService.get('start_page');
  switch(initScreen) {
    case 'About': {initScreen = '/about';} break;
    case 'Actions': {initScreen = '/actions';} break;
    case 'Community': {initScreen = '/community';} break;
    case 'Map': {initScreen = '/map';} break;
    case 'Profile': {initScreen = '/profile';} break;
    case 'Settings': {initScreen = '/settings';} break;
    default: { throw Exception('wrong start_page value: $initScreen'); } break;
  }

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
            '/map': (context) => MapRoute(),
            '/profile': (context) => ProfileRoute(),
            '/actions': (context) => ActionsRoute(),
            '/community': (context) => CommunityRoute(),
            '/settings': (context) => SettingsRoute(),
            '/about': (context) => AboutRoute(),
          },
        );
      }
    );
  }
}
