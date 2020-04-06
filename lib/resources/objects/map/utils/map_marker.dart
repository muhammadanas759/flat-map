import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapMarker {
  String id;
  String title;
  String description;
  LatLng position;
  double range;
  BitmapDescriptor icon;
  String action;

  MapMarker({
    String id,
    String title,
    String description,
    LatLng position,
    double range,
    BitmapDescriptor icon
  });

  Marker toMarker() => Marker(
    markerId: MarkerId(id),
    position: position,
    icon: icon,
    onTap: () {
      onTappedMarker(
          this.toMarker()
      );
    },
    infoWindow: InfoWindow(
      title: title,
      snippet: description,
    )
  );

  void onTappedMarker(Marker marker) {

  }

  void changePosition(LatLng position){
    position = position;
  }
}
