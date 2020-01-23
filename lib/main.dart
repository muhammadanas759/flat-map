import 'package:flutter/material.dart';
import './resources/routes/MapRoute.dart';
import './resources/routes/ProfileRoute.dart';
import './resources/routes/ActionsRoute.dart';
import './resources/routes/CommunityRoute.dart';
import './resources/routes/SettingsRoute.dart';
import './resources/routes/AboutRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlatMApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/home',
      routes: {
        // When navigating to the "/name" route, build the NameRoute widget.
        '/home': (context) => MapRoute(),
        '/profile': (context) => ProfileRoute(),
        '/actions': (context) => ActionsRoute(),
        '/community': (context) => CommunityRoute(),
        '/settings': (context) => SettingsRoute(),
        '/about': (context) => AboutRoute(),
      },
    );
  }
}
