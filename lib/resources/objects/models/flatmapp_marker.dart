import 'package:flatmapp/resources/objects/models/flatmapp_action.dart';


class FlatMappMarker {

  double position_x;
  double position_y;
  double range;
  double action_position;
  String title;
  String icon;
  String description;
  List<FlatMappAction> actions;

  FlatMappMarker(
    this.position_x,
    this.position_y,
    this.range,
    this.action_position,
    this.title,
    this.description,
    this.icon,
    this.actions
  );

  // override print
  String toString(){
    return '{'
      '"position_x": "${this.position_x}", '
      '"position_y": "${this.position_y}", '
      '"range": "${this.range}", '
      '"action_position": "${this.action_position}", '
      '"title": "${this.title}", '
      '"description": "${this.description}", '
      '"icon": "${this.icon}", '
      '"actions": "${this.actions}", '
    '}';
  }

  FlatMappMarker.fromJson(Map<String, dynamic> json) { fromJson(json); }
  FlatMappMarker.toJson() { toJson(); }

  void fromJson(Map<String, dynamic> marker){
    this.position_x = marker['position_x'];
    this.position_y = marker['position_y'];
    this.range = marker['range'];
    this.action_position = marker['action_position'];
    this.title = marker['title'];
    this.icon = marker['icon'];
    this.description = marker['description'];
    this.actions = actionsFromList(marker['actions']);
  }

  Map<String, dynamic> toJson(){
    return {
      'position_x': this.position_x,
      'position_y': this.position_y,
      'range': this.range,
      'action_position': this.action_position,
      'title': this.title,
      'icon': this.icon,
      'description': this.description,
      'actions': this.actions,
    };
  }

  List<FlatMappAction> actionsFromList(List<dynamic> actions_list){
    List<FlatMappAction> actions = [];
    actions_list.forEach((element) {
      actions.add(
          FlatMappAction(
            element['name'].toString(),
            element['icon'].toString(),
            element['action_position'],
            element['parameters'],
          )
      );
    });

    return actions;
  }
}