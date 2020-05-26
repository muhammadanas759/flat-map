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

  // NetLoader _netLoader = NetLoader();

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

      PreferenceDialogLink(
        'Change background theme',
        dialog: PreferenceDialog([
          RadioPreference(
            'Light Theme',
            'light',
            'ui_theme',
            isDefault: true,
            onSelect: () {
              DynamicTheme.of(context).setBrightness(Brightness.light);
            },
          ),
          RadioPreference(
            'Dark Theme',
            'dark',
            'ui_theme',
            onSelect: () {
              DynamicTheme.of(context).setBrightness(Brightness.dark);
            },
          ),
          ],
          title: 'Select application theme',
          // cancelText: 'Cancel',
          submitText: 'Close',
          onlySaveOnSubmit: false,
        ),
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
            PreferenceTitle('Local data', style: header()),
            CheckboxPreference(
              'Remove local markers',
              'remove_local',
              defaultVal: false,
              onEnable: () {
                // TODO confirm to remove local markers
                print("remove local markers");
              },
            ),
            PreferenceTitle('Outside data', style: header()),
            CheckboxPreference(
              'Remove backup markers',
              'remove_backup',
              defaultVal: false,
              onEnable: () {
                // TODO confirm to remove backup markers
                print("remove backup markers");
                // _netLoader.removeBackup()
              },
            ),
            CheckboxPreference(
              'Remove account',
              'remove_account',
              defaultVal: false,
              onEnable: () {
                // move to account removal form
                Navigator.pushNamed(context, '/erase_account');
              },
            ),
          ]),
        ),
      ], '!advanced_enabled'), // Use ! to get reversed boolean values

      // --------------------------------------------------------------------

//      PreferenceTitle('User'),
//      TextFieldPreference(
//        'Display Name',
//        'user_display_name',
//      ),
//      TextFieldPreference('E-Mail', 'user_email',
//          defaultVal: 'email@example.com'),
//      PreferenceText(
//        PrefService.getString('user_description') ?? '',
//        style: TextStyle(color: Colors.grey),
//      ),
//      PreferenceDialogLink(
//        'Edit description',
//        dialog: PreferenceDialog(
//          [
//            TextFieldPreference(
//              'Description',
//              'user_description',
//              padding: const EdgeInsets.only(top: 8.0),
//              autofocus: true,
//              maxLines: 2,
//            )
//          ],
//          title: 'Edit description',
//          cancelText: 'Cancel',
//          submitText: 'Save',
//          onlySaveOnSubmit: true,
//        ),
//        onPop: () => setState(() {}),
//      ),
//      PreferenceTitle('Content'),
//      PreferenceDialogLink(
//        'Content Types',
//        dialog: PreferenceDialog(
//          [
//            CheckboxPreference('Text', 'content_show_text'),
//            CheckboxPreference('Images', 'content_show_image'),
//            CheckboxPreference('Music', 'content_show_audio')
//          ],
//          title: 'Enabled Content Types',
//          cancelText: 'Cancel',
//          submitText: 'Save',
//          onlySaveOnSubmit: true,
//        ),
//      ),
//      PreferenceTitle('More Dialogs'),
//      PreferenceDialogLink(
//        'Android\'s "ListPreference"',
//        dialog: PreferenceDialog(
//          [
//            RadioPreference(
//                'Select me!', 'select_1', 'android_listpref_selected'),
//            RadioPreference(
//                'Hello World!', 'select_2', 'android_listpref_selected'),
//            RadioPreference('Test', 'select_3', 'android_listpref_selected'),
//          ],
//          title: 'Select an option',
//          cancelText: 'Cancel',
//          submitText: 'Save',
//          onlySaveOnSubmit: true,
//        ),
//      ),
//      PreferenceDialogLink(
//        'Android\'s "ListPreference" with autosave',
//        dialog: PreferenceDialog(
//          [
//            RadioPreference(
//                'Select me!', 'select_1', 'android_listpref_auto_selected'),
//            RadioPreference(
//                'Hello World!', 'select_2', 'android_listpref_auto_selected'),
//            RadioPreference(
//                'Test', 'select_3', 'android_listpref_auto_selected'),
//          ],
//          title: 'Select an option',
//          cancelText: 'Close',
//        ),
//      ),
//      PreferenceDialogLink(
//        'Android\'s "MultiSelectListPreference"',
//        dialog: PreferenceDialog(
//          [
//            CheckboxPreference('A enabled', 'android_multilistpref_a'),
//            CheckboxPreference('B enabled', 'android_multilistpref_b'),
//            CheckboxPreference('C enabled', 'android_multilistpref_c'),
//          ],
//          title: 'Select multiple options',
//          cancelText: 'Cancel',
//          submitText: 'Save',
//          onlySaveOnSubmit: true,
//        ),
//      ),


    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:

      easyPreferences(),

      // BODY
//      Column(
//        children: <Widget>[
//          easyPreferences(),
//
//          ExpansionTile(
//            leading: Icon(Icons.settings_applications),
//            title: Text("Advanced", style: bodyText()),
//            trailing: Icon(Icons.keyboard_arrow_down),
//            children: <Widget>[
//              ListTile(
//                title: Text(
//                  'Remove local markers',
//                  style: bodyText(),
//                ),
//                // trailing: Icon(Icons.keyboard_arrow_right),
//                leading: Icon(Icons.remove_circle_outline),
//                onLongPress: (){
//                  // TODO remove markers after alert dialog
//
//                },
//              ),
//
//              ListTile(
//                title: Text(
//                  'Restore settings to default',
//                  style: bodyText(),
//                ),
//                // trailing: Icon(Icons.keyboard_arrow_right),
//                leading: Icon(Icons.remove_circle),
//                onLongPress: (){
//                  // TODO restore settings to default after alert dialog
//                },
//              ),
//            ],
//          ),
//        ],
//      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}

