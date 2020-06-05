import 'package:flatmapp/resources/objects/loaders/net_loader.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


class SettingsRoute extends StatefulWidget {
  @override
  _SettingsRouteState createState() => _SettingsRouteState();
}

class _SettingsRouteState extends State<SettingsRoute> {

  NetLoader _netLoader = NetLoader();

  PreferencePage easyPreferences(){
    return PreferencePage([

      PreferenceTitle('General', style: header()),
      DropdownPreference(
        'Start Page',
        'start_page',
        defaultVal: 'Map',
        values: ['Map', 'Profile', 'Community', 'Settings', 'About'],
      ),

      PreferenceTitle('Personalization', style: header()),
      DropdownPreference(
        'Change background theme',
        'ui_theme',
        defaultVal: 'light',
        values: ['light', 'dark'],
        onChange: (value) {
          if(value == 'light'){
            DynamicTheme.of(context).setBrightness(Brightness.light);
          } else {
            DynamicTheme.of(context).setBrightness(Brightness.dark);
          }
        },
      ),

      PreferenceTitle('Advanced', style: header()),
      CheckboxPreference(
        'Enable Advanced Features',
        'advanced_enabled',
        onChange: () {
          setState(() {});
        },
        onDisable: () {
          PrefService.setBool('show_exp', false);
        },
      ),
      PreferenceHider([
        SwitchPreference(
          'Enable cloud save',
          'cloud_enabled',
          defaultVal: false,
        ),
        SwitchPreference(
          'Enable map loading',
          'map_enabled',
          defaultVal: false,
        ),
        SwitchPreference(
          'Enable isolate subprocess',
          'isolate_enabled',
          defaultVal: false,
        ),
        PreferencePageLink(
          'Delete data',
          leading: Icon(Icons.remove_circle),
          trailing: Icon(Icons.keyboard_arrow_right),
          page: PreferencePage([
//            PreferenceTitle('Local data', style: header()),
//            PreferenceText(
//              'Remove local markers',
//              leading: Icon(Icons.delete_forever),
//              onTap: () {
//
//              },
//            ),
            PreferenceTitle('Outside data', style: header()),
            PreferenceText(
              'Remove backup markers',
              leading: Icon(Icons.cloud_off),
              onTap: () {
                print("remove backup markers");
                _netLoader.removeBackup();
              },
            ),
            PreferenceText(
              'Remove account',
              leading: Icon(Icons.remove_circle),
              onTap: () {
                // move to account removal form
                Navigator.pushNamed(context, '/erase_account');
              },
            ),
          ]),
        ),
      ], '!advanced_enabled'), // Use ! to get reversed boolean values

    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:

      easyPreferences(),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
