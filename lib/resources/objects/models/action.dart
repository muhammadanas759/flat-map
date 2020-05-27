


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

  // TODO change names in server table from Action_Name and action_detail to name and parameters
  // override print
  String toString(){
    return '{Action_Name: ${this.name}, icon: ${this.icon}, '
    'action_position: ${this.action_position}, action_detail: ${this.parameters}}';
  }

  FlatMappAction.fromJson(Map<String, dynamic> json) { fromMap(json); }
  FlatMappAction.toJson() { toJson(); }

  void fromMap(Map<String, dynamic> action){
    this.name = action['name'];
    this.icon = action['icon'];
    this.action_position = action['action_position'];
    this.parameters = action['parameters'];
  }

  Map<String, dynamic> toJson() => {
    'name': this.name,
    'icon': this.icon,
    'action_position': this.action_position,
    'parameters': this.parameters,
  };
}