import 'package:flutter/material.dart';

Drawer sideBarMenu(context){
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 80.0,
          child: DrawerHeader(
              child:
              Text('', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                  color: Colors.green
              ),
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0)
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Profile'),
          onTap: () {
            // Navigate to the profile screen using a named route.
            Navigator.pushNamed(context, '/profile');
          },
        ),
        ListTile(
          leading: Icon(Icons.access_alarm),
          title: Text('Actions'),
          onTap: () {
            // Navigate to the profile screen using a named route.
            Navigator.pushNamed(context, '/actions');
          },
        ),
        ListTile(
          leading: Icon(Icons.language),
          title: Text('Community'),
          onTap: () {
            // Navigate to the profile screen using a named route.
            Navigator.pushNamed(context, '/community');
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.settings_applications),
          title: Text('Settings'),
          onTap: () {
            // Navigate to the profile screen using a named route.
            Navigator.pushNamed(context, '/settings');
            // Then close the drawer
            Navigator.pop(context);
          },
        ),ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('About'),
          onTap: () {
            // Navigate to the profile screen using a named route.
            Navigator.pushNamed(context, '/about');
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}