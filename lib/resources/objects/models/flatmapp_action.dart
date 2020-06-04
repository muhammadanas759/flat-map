import 'dart:convert';


class FlatMappAction {
  String name;
  String icon;
  double action_position;
  Map<String, dynamic> parameters;

  FlatMappAction(
    this.name,
    this.icon,
    this.action_position,
    this.parameters
  );

  // Redirecting constructors
  FlatMappAction.empty() : this("", "", 0, {});

  // TODO change names in server table from Action_Name and action_detail to name and parameters
  // override print
  String toString(){
    return '{"Action_Name": "${this.name}", "icon": "${this.icon}", '
    '"action_position": "${this.action_position}", "action_detail": ${this.parameters}}';
  }

  FlatMappAction.fromJson(Map<String, dynamic> json) { fromMap(json); }
  FlatMappAction.toJson() { toJson(); }

  void fromMap(Map<String, dynamic> action) {
    this.name = action['Action_Name'].toString(); // TODO changed from name to Action_Name to meet server requirements
    this.icon = action['icon'].toString();
    this.action_position = action['action_position'].toDouble();
    this.parameters = json.decode(action['action_detail']); // TODO changed from parameters to action_detail to meet server requirements
  }

  Map<String, dynamic> toJson() => {
    'Action_Name': this.name, // TODO changed from name to Action_Name to meet server requirements
    'icon': this.icon,
    'action_position': this.action_position,
    'action_detail': json.encode(this.parameters), // TODO changed from parameters to action_detail to meet server requirements
  };
}
