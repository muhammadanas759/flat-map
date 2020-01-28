import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

import '../objects/widgets/text_styles.dart';
import '../objects/map/google_maps_widget.dart';

import '../objects/widgets/side_bar_menu.dart';
import '../objects/widgets/app_bar.dart';


class MapRoute extends StatefulWidget {
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:

      // GOOGLE MAPS
      PrefService.get('map_enabled') != true
        ? textInfo('Map disabled' ?? '')
        : GoogleMapWidget(),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),

      floatingActionButton: new FloatingActionButton(
        onPressed: () {}, // TODO - function to add new pointers
        tooltip: 'Add new pointer',
        child: new Icon(Icons.add),
        elevation: 4.0,
      ),

      // NAVIGATION BAR
      // bottomNavigationBar: createBottomAppBar,
      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /*
  BottomAppBar createBottomAppBar(){
    return BottomAppBar(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(child: IconButton(icon: Icon(Icons.home)),),
          Expanded(child: IconButton(icon: Icon(Icons.show_chart)),),
          Expanded(child: new Text('')),
          Expanded(child: IconButton(icon: Icon(Icons.tab)),),
          Expanded(child: IconButton(icon: Icon(Icons.settings)),),
        ],
      ),
    );
  }*/
// =============================================================================
}
