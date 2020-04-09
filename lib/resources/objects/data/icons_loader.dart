import 'package:flatmapp/resources/objects/widgets/text_styles.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// class providing paths to markers icons
class IconsLoader {

  // ===========================================================================
  // https://img.icons8.com/office/80/000000/marker.png
  // https://img.icons8.com/officel/80/000000/place-marker.png
  // https://img.icons8.com/dusk/80/000000/order-delivered.png
  final Map<String, String> markerImageLocal = {
    'default':       'assets/icons/marker.png',
    'pointer_place': 'assets/icons/place-marker.png',
    'pin':           'assets/icons/map-pin.png',

    'user':          'assets/icons/street-view.png',
    'clock':         'assets/icons/clock--v1.png',
    'post':          'assets/icons/new-post.png',
    'party':         'assets/icons/party-baloons.png',
    'gps':           'assets/icons/gps-device.png',

    'home':          'assets/icons/order-delivered.png',
    'office':        'assets/icons/link-company-parent.png',
    'factory':       'assets/icons/factory.png',
    'religion':      'assets/icons/city-church.png',
    'statue':        'assets/icons/statue.png',
    'parliament':    'assets/icons/parliament.png',
    'buildings':     'assets/icons/city-buildings.png',

    'tram':          'assets/icons/tram.png',
    'taxi':          'assets/icons/taxi.png',
    'train':         'assets/icons/train.png',
    'subway':        'assets/icons/subway.png',
    'car':           'assets/icons/car.png',

    'no_entry':      'assets/icons/no-entry.png',
    'no_mobile':     'assets/icons/no-mobile-devices.png',

    'biohazard':     'assets/icons/biohazard.png',
    'radioactive':   'assets/icons/radio-active.png',
    'water':         'assets/icons/water.png',
    'meal':          'assets/icons/meal.png',
  };

  // ===========================================================================
  // TODO function is delayed and therefore returns null (and after, when nobody cares, image)
  BitmapDescriptor getMarkerImage(
      String name, {double targetWidth}) {
    assert(name != null);

    BitmapDescriptor icon;

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        size: Size(targetWidth, targetWidth),
      ),
      markerImageLocal[name],
    ).then((image){icon = image;});

    return icon;
  }

  // ===========================================================================
  Widget _iconsListView(BuildContext context, ScrollController scrollController) { // ignore: unused_element
    return ListView.builder(
      controller: scrollController,
      itemCount: markerImageLocal.length,
      itemBuilder: (context, index) {
        String key = markerImageLocal.keys.elementAt(index);
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(markerImageLocal[key]),
            ),
            title: Text(key, style: bodyText()),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // do something
              print(key);
            },
          ),
        );
      },
    );
  }
}