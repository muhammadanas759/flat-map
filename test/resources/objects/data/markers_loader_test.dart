import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test/test.dart';
import 'package:flatmapp/resources/objects/data/markers_loader.dart';

void main() {
  group('Markters_Loader', () {
    test('Simple adding and removing markers ', ()
    {
      final markerLoader = MarkerLoader.test();

      markerLoader.addMarker(id: "test1",
          position: LatLng(-43.0, 170.0),
          icon: "default",
          title: "test markter 1",
          description: "marker presenting chosen position 1",
          range: 12.5);

      markerLoader.addMarker(id: "test2",
          position: LatLng(-73.0, 120.0),
          icon: "default",
          title: "test marker 2",
          description: "marker presenting chosen position 2",
          range: 11.5);

      markerLoader.removeMarker(id: "test1");

      expect(markerLoader.googleMarkers["test1"], null);
      expect(markerLoader.zones["test1"], null);
    });


  });
}