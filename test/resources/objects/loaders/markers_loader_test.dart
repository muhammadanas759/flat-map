import 'package:flatmapp/resources/objects/models/flatmapp_marker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
import 'package:preferences/preference_service.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  group('Markters_Loader', () {
    test('Simple adding marker test', (){
      final markerLoader = MarkerLoader();

      markerLoader.addMarker(
        id: "test1",
        position: LatLng(-43.0, 170.0),
        icon: "default",
        title: "test markter 1",
        description: "marker presenting chosen position 1",
        range: 12.5
      );

      FlatMappMarker _marker = markerLoader.getMarkerDescription("test1");

      expect(_marker.position_x, -43.0);
      expect(_marker.position_y, 170.0);
      expect(_marker.title, "test markter 1");
      expect(_marker.description, "marker presenting chosen position 1");
      expect(_marker.range, 12.5);
      expect(_marker.icon, "default");

    });
    test('Simple removing marker test', () {

      final markerLoader = MarkerLoader();

      markerLoader.addMarker(
          id: "test1",
          position: LatLng(-43.0, 170.0),
          icon: "default",
          title: "test markter 1",
          description: "marker presenting chosen position 1",
          range: 12.5
      );

      markerLoader.addMarker(
          id: "test2",
          position: LatLng(-73.0, 120.0),
          icon: "default",
          title: "test marker 2",
          description: "marker presenting chosen position 2",
          range: 11.5
      );

      markerLoader.removeMarker(
          id: "test1"
      );
      List<String> _keys = markerLoader.getDescriptionsKeys();
      expect(_keys.indexOf("test1"), -1);
      expect(markerLoader.googleMarkers["test1"], null);
      expect(markerLoader.zones["test1"], null);
      });

    test('Simple editing markers test', (){
      final markerLoader = MarkerLoader();
      markerLoader.addMarker(
          id: "test1",
          position: LatLng(70.0, 20.0),
          icon: "default",
          title: "test markter 1",
          description: "marker presenting chosen position 1",
          range: 12.5
      );

      FlatMappMarker _marker = markerLoader.getMarkerDescription("test1");

      expect(_marker.position_x, 70.0);
      expect(_marker.position_y, 20.0);

      markerLoader.addMarker(
          id: "test1",
          position: LatLng(-73.0, 120.0),
          icon: "default",
          title: "test markter 1",
          description: "marker presenting chosen position 1",
          range: 12.5
      );

      _marker = markerLoader.getMarkerDescription("test1");

      expect(_marker.position_x, -73.0);
      expect(_marker.position_y, 120.0);
    });
  });
}