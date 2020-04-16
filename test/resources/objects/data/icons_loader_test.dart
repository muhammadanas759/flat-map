import 'package:test/test.dart';
import 'package:flatmapp/resources/objects/data/icons_loader.dart';


void main() {
  group('Icons_Loader', () {
    test('Simple adding and removing icons ', (){
      final iconsLoader = new IconsLoader();

      expect(iconsLoader.markerImageLocal["default"], 'assets/icons/marker.png');
    });
  });
}