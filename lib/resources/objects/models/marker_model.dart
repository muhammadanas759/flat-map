

// https://flutter.dev/docs/cookbook/persistence/sqlite

class MarkerModel {
  final String id;
  final double position_x;
  final double position_y;
  final double range;
  final String icon;
  final String title;
  final String description;
  final List<dynamic> actions;

  MarkerModel({
    this.id,
    this.position_x,
    this.position_y,
    this.range,
    this.icon,
    this.title,
    this.description,
    this.actions,
  });
}
