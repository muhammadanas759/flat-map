import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';
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

      //print(markerLoader.markersDescriptions);
      //print(markerLoader.zones);

      expect(markerLoader.markersDescriptions["test1"]["position_x"], -43.0);
      expect(markerLoader.markersDescriptions["test1"]["position_y"], 170.0);
      expect(markerLoader.markersDescriptions["test1"]["title"], "test markter 1");
      expect(markerLoader.markersDescriptions["test1"]["description"], "marker presenting chosen position 1");
      expect(markerLoader.markersDescriptions["test1"]["range"], 12.5);
      expect(markerLoader.markersDescriptions["test1"]["icon"], "default");

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

      expect(markerLoader.markersDescriptions["test1"]["position_x"], 70.0);
      expect(markerLoader.markersDescriptions["test1"]["position_y"], 20.0);

      markerLoader.addMarker(
          id: "test1",
          position: LatLng(-73.0, 120.0),
          icon: "default",
          title: "test markter 1",
          description: "marker presenting chosen position 1",
          range: 12.5
      );

      expect(markerLoader.markersDescriptions["test1"]["position_x"], -73.0);
      expect(markerLoader.markersDescriptions["test1"]["position_y"], 120.0);
    });
  });
}