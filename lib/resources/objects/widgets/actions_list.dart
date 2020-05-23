import 'package:flatmapp/resources/objects/loaders/actions_loader.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:flatmapp/resources/objects/widgets/text_form_fields.dart';
import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/material.dart';

import 'dart:async';


// class providing actions list for markers
class ActionsList {
  MarkerLoader _markerLoader;

  ActionsList(MarkerLoader markerLoader){
    this._markerLoader = markerLoader;
  }

  Future<void> _raiseAlertDialog(
      BuildContext context, var id, var index, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Remove action?"),
            content: Text(
                "You are about to remove action\n" + description
            ),
            actions: [
              // set up the buttons
              FlatButton(
                child: Text("no nO NO"),
                onPressed:  () {
                  // dismiss alert
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("HELL YEAH"),
                onPressed:  () {
                  // remove marker
                  _markerLoader.removeMarkerAction(id: id, index: index);
                  // save markers state to file
                  _markerLoader.saveMarkers();
                  // dismiss alert
                  Navigator.of(context).pop();
                },
              ),
            ]
        );
      },
    );
  }

  void addAction(context){
    // Navigate to the icons screen using a named route.
    Navigator.pushNamed(context, '/actions');
  }

  Widget buildActionsList(BuildContext context, String id) {
    // actions list
    // https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview
    // https://api.flutter.dev/flutter/material/ReorderableListView-class.html

    // var id = PrefService.get('selected_marker');

    var _actionsLoader = ActionsLoader();

    List<dynamic> _actionsList = _markerLoader.getMarkerActions(
      id: id
    );

    return Expanded(
      child: _actionsList == null ?
      Card( //                           <-- Card widget
        child: ListTile(
          title: Text(
              "no actions added",
              style: bodyText()
          ),
        ),
      ) :
      ListView.builder(
        shrinkWrap: true,
        itemCount: _actionsList.length + 1,
        itemBuilder: (context, index) {
          if (index == _actionsList.length){
            // add last element - card "add marker"
            return addActionCard(
              tooltip: "Add action",
              onPressedMethod: () {
                addAction(context);
              },
            );
          } else {
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
                trailing: Icon(Icons.delete_forever),
                onTap: () {
                  // remove action with alert dialog
                  _raiseAlertDialog(context, id, index, _actionsList[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}


