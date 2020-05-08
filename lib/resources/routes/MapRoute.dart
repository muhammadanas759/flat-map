import 'package:flatmapp/resources/objects/data/actions_loader.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';

import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
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

  ActionsLoader _actionsLoader = ActionsLoader();

  // google map controller
  final Completer<GoogleMapController> _mapController = Completer();

  // sliding form controller
  PanelController _slidingFormController = new PanelController();

  // form controllers:
  TextEditingController _formTitleController = new TextEditingController();
  TextEditingController _formDescriptionController = new TextEditingController();

  // map style preset
  final String _preset = PrefService.get('ui_theme');

  // map zoom
  double _currentZoom = 18;

  // Map loading flag
  bool _isMapLoading = true;
  // Markers loading flag
  bool _areMarkersLoading = true;

  // Form variables
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formMarkerData = {
    'id': "temporary",
    'title': "temporary marker",
    'description': "marker presenting chosen position",
    'range': 10,
    'actions': [],
  };

  @override
  void initState() {
    super.initState();

    // update form
    updateFormData();

    // update camera position
    updateCameraPosition();
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

    // notify about finished markers loading
    setState(() {
      _areMarkersLoading = false;
    });
  }

  // add marker in the place where user touched the map
  Future _mapTap(LatLng position) async {
    // if the form is opened, close it. In other case, move marker
    if(_slidingFormController.isPanelOpen){
      // close panel
      _slidingFormController.close();
    } else {
      setState(() {
        // change temporary position
        widget._markerLoader.addTemporaryMarker(position);

        // change selected marker in prefs
        PrefService.setString('selected_marker', 'temporary');

        // save markers state to file
        widget._markerLoader.saveMarkers();
      });
    }
  }

  // open marker form if user pressed the map
  Future _mapLongPress(LatLng position) async {

    // reload icon in form - requires setState update on preferences
    // TODO THIS CAUSES Exception - NEED BETTER SOLUTION
    setState(() { });

    // update form
    updateFormData();
    // open sliding form
    _slidingFormController.open();
  }

  // update camera position basing on selected marker
  CameraPosition updateCameraPosition(){
    return CameraPosition(
      target: widget._markerLoader.getMarker(
          id: PrefService.get('selected_marker')
      ).position,
      zoom: _currentZoom,
    );
  }

  Widget _googleMapWidget(){
    return GoogleMap(
      myLocationEnabled: true,
      mapToolbarEnabled: false,
      initialCameraPosition: updateCameraPosition(),
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
  void updateFormData(){
    var temp = widget._markerLoader.markersDescriptions[
      PrefService.get('selected_marker')
    ];
    // set marker data to temporary marker
    if (temp != null){
      _formMarkerData['title'] = temp['title'];
      _formMarkerData['description'] = temp['description'];
      _formMarkerData['range'] = temp['range'].toInt();
    }

    // update controllers
    _formTitleController.text = _formMarkerData['title'];
    _formDescriptionController.text = _formMarkerData['description'];
  }

  Widget _closeFormButton(){
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightGreen, width: 5.0),
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          //This keeps the splash effect within the circle
          borderRadius: BorderRadius.circular(1000.0),
          child: Padding(
            padding:EdgeInsets.all(1.0),
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              color: Colors.white,
              tooltip: 'Close form',
              onPressed: () {
                _closePanel(context);
              },
            ),
          ),
        ),
      )
    );
  }

  Widget _iconChangeButton(){
    return Expanded(
      child: SizedBox(
        height: 60.0,
        // icon change button
        child: Container(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: FlatButton(
              onPressed: (){
                // Navigate to the icons screen using a named route.
                Navigator.pushNamed(context, '/icons');
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset(
                widget._markerLoader.iconsLoader.markerImageLocal[
                  PrefService.get('selected_icon')
                ]
              )
            )
          )
        ),
      ),
    );
  }

  Widget _buildMarkerNameField(context) {
    return TextFormField(
      controller: _formTitleController,
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
      controller: _formDescriptionController,
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
      // initialValue: _formMarkerData['range'],
      initialValue: widget._markerLoader.getRange(
          id: PrefService.get('selected_marker')
      ),
      onSaved: (value) => this._formMarkerData['range'] = value,
    );
  }

  Widget _buildActionsList(BuildContext context) {
    // TODO actions list
    // https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview
    // https://api.flutter.dev/flutter/material/ReorderableListView-class.html

    List<String> _actionsList = widget._markerLoader.getMarkerActions(
        id: PrefService.get('selected_marker'));

    return _actionsList == null ?
    Card( //                           <-- Card widget
      child: ListTile(
        title: Text(
            "no actions added",
            style: bodyText()
        ),
      ),
    ) :
    ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _actionsList.length,
      itemBuilder: (context, index) {
        return Card( //                           <-- Card widget
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                  _actionsLoader.actionsMap[_actionsList[index]]
              ),
            ),
            title: Text(
                _actionsList[index],
                style: bodyText()
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // TODO operate action tap on marker form
            },
          ),
        );
      },
    );
  }

  void _saveMarker(){
    // save form
    _formKey.currentState.save();

    var _selectedMarkerId = PrefService.get('selected_marker');

    setState(() {
      // adding a new marker to map
      widget._markerLoader.addMarker(
        id: _selectedMarkerId == 'temporary' ?
            widget._markerLoader.generateId() : _selectedMarkerId,
        position: widget._markerLoader.getMarker(id: _selectedMarkerId).position,
        icon: PrefService.get('selected_icon'),
        title: _formMarkerData['title'],
        description: _formMarkerData['description'],
        range: _formMarkerData['range'].toDouble(),
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
    Marker tempMarker = widget._markerLoader.getMarker(
        id: PrefService.get('selected_marker')
    );
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
                'Selected marker position:\n'
                    '${tempMarker.position.latitude},\n'
                    '${tempMarker.position.longitude}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: bodyText(),
              ),
              _closeFormButton(),
            ],
          ),
          SizedBox(height: 10),
          _buildMarkerNameField(context),
          SizedBox(height: 10),
          _buildMarkerDescriptionField(context),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // icon change button
              _iconChangeButton(),
              // range counter
              _buildMarkerRangeField(),
            ],
          ),

          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              textFieldButton(text: "Add marker", onPressedMethod: (){
                // submit form and add marker to dictionary
                _saveMarker();
              }),
              SizedBox(width: 20),
              textFieldButton(text: "Add action", onPressedMethod: (){
                // Navigate to the icons screen using a named route.
                Navigator.pushNamed(context, '/actions');
              }),
            ],
          ),
          SizedBox(width: 10),

          _buildActionsList(context),
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
            color: _preset == 'dark' ? Colors.black : Colors.white,
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
