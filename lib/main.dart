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
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'package:flutter/services.dart';
import 'package:isolate_handler/isolate_handler.dart';


// create a new IsolateHandler instance used to spawn isolates.
final isolates = IsolateHandler();

// store channels in a top-level Map for convenience
const Map<String, MethodChannel> channels = {
  'trigger': const MethodChannel('isolates.main/trigger'),
};

int counter = 0;

// store chosen starting route
String initScreen;

// data loader
final MarkerLoader _markerLoader = MarkerLoader();

// TODO CHECK https://pub.dev/packages/isolate_handler
// =============================================================================
// -------------------- TRIGGER ISOLATE SECTION --------------------------------

// This function happens in the isolate
void triggerEntryPoint(HandledIsolateContext context) {

  // initiate trigger loader in isolated process
  // TriggerLoader _triggerLoader = TriggerLoader();

  // Calling initialize from the entry point with the context is
  // required if communication is desired. It returns a messenger which
  // allows listening and sending information to the main isolate.
  final messenger = HandledIsolate.initialize(context);

  // Triggered every time data is received from the main isolate
  messenger.listen((data) async {
    // final int result = await channels['trigger'].invokeMethod('getNewCount');
    messenger.send("cool cool cool cool cool coool cool cool cool");
  });
}

void onReceiveFromTrigger(String confirmation){
  // onReceive is executed every time data is received from the spawned process

  // show confirmation of ongoing process
  print(confirmation);
}

void killTrigger(){
  isolates.kill("trigger");
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
//  isolates.spawn(
//      triggerEntryPoint,
//      // name the isolate in order to access it on sending data or disposal
//      name: "trigger",
//      // onReceive is executed every time data is received from the spawn
//      onReceive: onReceiveFromTrigger,
//      // executed once when spawned isolate is ready for communication
//      onInitialized: () => isolates.send(counter, to: "trigger"),
//      channels: channels.values.toList()
//  );

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
