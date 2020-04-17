import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';
import 'package:flatmapp/resources/objects/widgets/side_bar_menu.dart';
import 'package:flatmapp/resources/objects/widgets/app_bar.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:preferences/preferences.dart';

import 'dart:async';


class MapRoute extends StatefulWidget {

  // data loader
  MarkerLoader _markerLoader = MarkerLoader();

  MapRoute(this._markerLoader, {Key key}): super(key: key);

  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  // ===========================================================================
  // -------------------- INIT VARIABLES SECTION -------------------------------

  // google map controller
  final Completer<GoogleMapController> _mapController = Completer();

  // sliding form controller
  PanelController _slidingFormController = new PanelController();

  // map style preset
  final String _preset = PrefService.get('ui_theme');

  // selected marker
  String _selectedMarkerId = PrefService.get('selected_marker');

  // Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  // Map loading flag
  bool _isMapLoading = true;
  // Markers loading flag
  bool _areMarkersLoading = true;

  // Form variables
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formMarkerData = {
    'title': '',
    'description': '',
    'range': 10,
    'actions': []
  };

  @override
  void initState() {
    super.initState();
  }

  // ===========================================================================
  // -------------------- GOOGLE MAPS WIDGET SECTION ---------------------------
  // set custom map style
  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style_$_preset.json');
    controller.setMapStyle(value);
  }

  // Called when the Google Map widget is created.
  // Updates the map loading state and initializes markers.
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
    widget._markerLoader.loadMarkers();

    // notify about finished markers loading
    setState(() {
      _areMarkersLoading = false;
    });
  }

  // add marker in the place where user touched the map
  Future _mapTap(LatLng position) async {
    setState(() {
      // LatLng(52.466699, 16.926961)

      // change temporary position
      widget._markerLoader.addTemporaryMarker(position);

      // save markers state to file
      widget._markerLoader.saveMarkers();
    });
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
        target: _selectedMarkerId == null ?
        widget._markerLoader.getTemporaryMarker().position :
        widget._markerLoader.googleMarkers[_selectedMarkerId].position,
        zoom: _currentZoom,
      ),
      markers: Set<Marker>.of(widget._markerLoader.googleMarkers.values),
      circles: Set<Circle>.of(widget._markerLoader.zones.values),
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
  Widget _buildMarkerNameField(context) {
    return TextFormField(
      initialValue: _formMarkerData['title'],
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Marker title",
          hintTextStr: "Marker title goes here"
      ),
      onSaved: (String value) {
        _formMarkerData['title'] = value;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (String value) {
        _formMarkerData['title'] = value;
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget _buildMarkerDescriptionField(context) {
    return TextFormField(
      initialValue: _formMarkerData['description'],
      style: bodyText(),
      decoration: textFieldStyle(
          labelTextStr: "Marker description",
          hintTextStr: "Marker description goes here"
      ),
      onSaved: (String value) {
        _formMarkerData['description'] = value;
      },
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (String value) {
        _formMarkerData['description'] = value;
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Widget _buildMarkerRangeField() {
    return CounterFormField(
      initialValue: _formMarkerData['range'],
      onSaved: (value) => this._formMarkerData['range'] = value,
    );
  }

  void _saveMarker(){
    // save form
    _formKey.currentState.save();

    setState(() {
      // adding a new marker to map
      widget._markerLoader.addMarker(
          id: widget._markerLoader.generateId(),
          position: widget._markerLoader.getTemporaryMarker().position,
          icon: "default",
          title: _formMarkerData['title'],
          description: _formMarkerData['description'],
          range: _formMarkerData['range'].toDouble()
      );
    });

    // close form panel
    _closePanel(context);
  }

  void _closePanel(context){
    // close keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    // close panel
    _slidingFormController.close();
  }

  Widget _markerAddForm(context){
    Marker tempMarker = widget._markerLoader.getTemporaryMarker();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Temporary marker position:\n'
                    '${tempMarker.position.latitude},\n'
                    '${tempMarker.position.longitude}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: bodyText(),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                tooltip: 'Close form',
                onPressed: () {
                  _closePanel(context);
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildMarkerNameField(context),
          SizedBox(height: 10),
          _buildMarkerDescriptionField(context),
          SizedBox(height: 10),
          _buildMarkerRangeField(),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                elevation: 0.0,
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.grey),
                ),
                padding: EdgeInsets.all(20.0),
                onPressed: (){
                  _saveMarker();
                },
                child: Text(
                  "Add marker",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 20),
              textFieldButton(text: "Add action", onPressedMethod: (){

              }),
            ],
          ),
          SizedBox(width: 10),
        ],
      )
    );
  }

  // ===========================================================================
  // -------------------- MAIN MAP WIDGET SECTION ------------------------------
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
            panel: _markerAddForm(context),
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
