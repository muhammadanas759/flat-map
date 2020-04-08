import 'dart:async';

import 'package:flatmapp/resources/objects/data/icons_loader.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:preferences/preferences.dart';

import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class MapRoute extends StatefulWidget {
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {

  // google map controller
  final Completer<GoogleMapController> _mapController = Completer();

  // sliding form controller
  PanelController _slidingFormController = new PanelController();

  // temporary touch position
  LatLng _temporaryMarkerPosition = LatLng(52.466699, 16.926961);

  // map style preset
  final String _preset = PrefService.get('ui_theme');

  // Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  // data loader
  final MarkerLoader _markerLoader = MarkerLoader();

  // Map loading flag
  bool _isMapLoading = true;
  // Markers loading flag
  bool _areMarkersLoading = true;

  @override
  void initState() {
    super.initState();
  }

  // set custom map style
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style_$_preset.json');
    controller.setMapStyle(value);
  }

  // Init all the markers with network images and update the loading state.
  void _initMarkers() async {

    await _markerLoader.loadMarkers();

    // notify about finished markers loading
    setState(() {
      _areMarkersLoading = false;
    });
  }

  void addMarker({Marker marker}) {
    setState(() {
      // adding a new marker to map
      _markerLoader.googleMarkers[_markerLoader.generateId()] = marker;
    });
  }

  // TODO change marker procedure
  void changeMarker({String id, Marker marker}){
    setState(() {
      // change marker
      _markerLoader.googleMarkers[
        _markerLoader.generateId()
      ] = marker;
    });
  }

  // ===========================================================================
  // -------------------- GOOGLE MAPS WIDGET SECTION ---------------------------

  // Called when the Google Map widget is created.
  // Updates the map loading state and inits the markers.
  void _onMapCreated(GoogleMapController controller) {

    // set custom map style
    _setStyle(controller);

    // crete map controller
    _mapController.complete(controller);

    // notify about finished map loading
    setState(() {
      _isMapLoading = false;
    });

    // load markers
    _initMarkers();
  }

  // add marker in the place where user touched the map
  Future _mapTap(LatLng position) async {
    _temporaryMarkerPosition = position;
    Marker marker = await _markerLoader.temporaryMarker(_temporaryMarkerPosition);
    addMarker(
      marker: marker
    );
  }

  // open marker add formula if user pressed the map
  Future _mapLongPress(LatLng position) async {
    // open sliding form
    _slidingFormController.open();
  }

  Widget _googleMapWidget(){
    return GoogleMap(
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      initialCameraPosition: CameraPosition(
        target: _temporaryMarkerPosition,
        zoom: _currentZoom,
      ),
      markers: Set<Marker>.of(_markerLoader.googleMarkers.values),
      circles: Set<Circle>.of(_markerLoader.zones.values),
      onMapCreated: (controller) => _onMapCreated(controller),

      // call this function when tapped on the map
      onTap: (position){
        _mapTap(position);
      },
      // call this function when long pressed on the map
      onLongPress: (position) {
        _mapLongPress(position);
      },
    );
  }

  // ===========================================================================
  // -------------------- MARKER FORM WIDGET SECTION ---------------------------

  final IconsLoader icons = IconsLoader();

  Widget _iconsListView(BuildContext context, ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: icons.markerImageLocal.length,
      itemBuilder: (context, index) {
        String key = icons.markerImageLocal.keys.elementAt(index);
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(icons.markerImageLocal[key]),
            ),
            title: Text(key, style: bodyText()),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // do something
              print(key);
            },
          ),
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formMarkerData = {
    'name': '',
    'range': 10.0,
    'actions': []
  };
  final focusPassword = FocusNode();

  Widget _buildMarkerNameField(context) {
    return TextFormField(
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Marker name",
          hintTextStr: "Marker name goes here"
      ),
      onSaved: (String value) {
        _formMarkerData['name'] = value;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusPassword);
      },
    );
  }

  Widget _buildMarkerRangeField() {
    return TextFormField(
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Marker range",
          hintTextStr: "Marker range goes here"
      ),
      keyboardType: TextInputType.number,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty) {
          return 'Marker range can not be empty';
        }
      },
      onSaved: (String value) {
        _formMarkerData['range'] = value;
      },
      focusNode: focusPassword,
      onFieldSubmitted: (v) {
        _submitForm();
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  void _saveMarker(){
    // _submitForm();
    _closePanel();
  }

  void _closePanel(){
    // close panel
    _slidingFormController.close();
  }

  Widget _markerAddForm(){
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Text(
            'Temporary marker position:\n'
                '${_temporaryMarkerPosition.latitude}, '
                '${_temporaryMarkerPosition.longitude}',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: bodyText(),
          ),
          SizedBox(height: 20),
          _buildMarkerNameField(context),
          SizedBox(height: 20),
          _buildMarkerRangeField(),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              textFieldButton(text: "Save marker", onPressedMethod: _saveMarker),
              SizedBox(width: 20),
              textFieldButton(text: "Close form", onPressedMethod: _closePanel),
            ],
          ),

          textFieldButton(text: "Add action", onPressedMethod: _saveMarker),
          SizedBox(width: 20),
        ],
      )
    );
  }

  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body:

      // GOOGLE MAPS
      PrefService.get('map_enabled') != true
        ? textInfo('Map is disabled' ?? '')
        : Stack(
        children: <Widget>[
          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: Center(
                child: CircularProgressIndicator()
            ),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            textInfo('Loading markers'),

          SlidingUpPanel(
            minHeight: 0,
            padding: EdgeInsets.only(left: 30, right: 30),
            isDraggable: false,
            defaultPanelState: PanelState.CLOSED,
            controller: _slidingFormController,
            panel: _markerAddForm(),
            body: Opacity(
                opacity: _isMapLoading ? 0 : 1,
                // Google Map widget
                child: _googleMapWidget(),
              ),
          ),
        ],
      ),

      // SIDE PANEL MENU
      drawer: sideBarMenu(context),
    );
  }
}
