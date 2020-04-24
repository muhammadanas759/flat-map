import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flatmapp/resources/objects/data/trigger_loader.dart';

import 'package:flatmapp/resources/extensions.dart';


void main() {
  group(
    'Trigger_Loader', () {

      TestWidgetsFlutterBinding.ensureInitialized();
      final triggerLoader = TriggerLoader();

      test(
        'Get position from address', () async {
          var temp = await triggerLoader.getPositionFromAddress(
              address: "ul, Uniwersytetu Poznańskiego 4, 61-614 Poznań"
          );
          expect(
            temp,
            LatLng(52.466758, 16.926854),
          );
        }
      );

      test(
        'Get address from position', () async {
          var temp = await triggerLoader.getAddressFromPosition(
            position: LatLng(52.466758, 16.926854),
          );
          expect(
            temp,
            "ul, Uniwersytetu Poznańskiego 4, 61-614 Poznań"
          );
        }
      );

      test(
        'Get distance between positions', () async {
          var temp = await triggerLoader.getDistanceBetweenPositions(
            position1: LatLng(52.466758, 16.926854),
            position2: LatLng(52.467189, 16.924966),
          );
          expect(
            temp.toPrecision(2),
            136.98,
          );
        }
      );

      test(
        'Get distance between addresses', () async {
          var temp = await triggerLoader.getDistanceBetweenAddresses(
            address1: "ul, Uniwersytetu Poznańskiego 4, 61-614 Poznań",
            address2: "ul, Uniwersytetu Poznańskiego 6, 61-614 Poznań",
          );
          expect(
            temp.toPrecision(2),
            136.98,
          );
        }
      );

    }
  );
}