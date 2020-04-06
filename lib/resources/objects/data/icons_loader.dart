import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


// class providing paths to markers icons
class IconsLoader {

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

  /// Map of icon images urls used on normal markers
  final Map<String, String> _markerImageUrl = {
    'default':       'https://img.icons8.com/office/80/000000/marker.png',
    'pointer_place': 'https://img.icons8.com/officel/80/000000/place-marker.png',
    'pin':           'https://img.icons8.com/office/80/000000/map-pin.png',

    'user':          'https://img.icons8.com/office/80/000000/street-view.png',
    'clock':         'https://img.icons8.com/color/48/000000/clock--v1.png',
    'post':          'https://img.icons8.com/office/80/000000/new-post.png',
    'party':         'https://img.icons8.com/office/80/000000/party-baloons.png',
    'gps':           'https://img.icons8.com/office/80/000000/gps-device.png',

    'home':          'https://img.icons8.com/dusk/80/000000/order-delivered.png',
    'office':        'https://img.icons8.com/office/80/000000/link-company-parent.png',
    'factory':       'https://img.icons8.com/office/80/000000/factory.png',
    'religion':      'https://img.icons8.com/office/80/000000/city-church.png',
    'statue':        'https://img.icons8.com/office/80/000000/statue.png',
    'parliament':    'https://img.icons8.com/office/80/000000/parliament.png',
    'buildings':     'https://img.icons8.com/office/80/000000/city-buildings.png',

    'tram':          'https://img.icons8.com/office/80/000000/tram.png',
    'taxi':          'https://img.icons8.com/office/80/000000/taxi.png',
    'train':         'https://img.icons8.com/office/80/000000/train.png',
    'subway':        'https://img.icons8.com/office/80/000000/subway.png',
    'car':           'https://img.icons8.com/office/80/000000/car.png',

    'no_entry':      'https://img.icons8.com/office/80/000000/no-entry.png',
    'no_mobile':     'https://img.icons8.com/office/80/000000/no-mobile-devices.png',

    'biohazard':     'https://img.icons8.com/office/80/000000/biohazard.png',
    'radioactive':   'https://img.icons8.com/office/80/000000/radio-active.png',
    'water':         'https://img.icons8.com/office/80/000000/water.png',
    'meal':          'https://img.icons8.com/office/80/000000/meal.png',
  };

  // map of loaded icons, filled during constructions
  Map<String, BitmapDescriptor> _iconsLoaded;

  // return image from name
  BitmapDescriptor getIcon(String name){
    if (_iconsLoaded?.containsKey(name) ?? false) {
      return _iconsLoaded[name];
    }
    throw("no value like $name in IconsLoader iconsLoaded map. Available: $_iconsLoaded");
  }

  // method for loading all icons - TODO performance check
  void loadingAllIcons(){
    _markerImageUrl.forEach((String iconName, String url) {
      getMarkerImage(url).then((BitmapDescriptor value){
          // _iconsLoaded[iconName] = value;
        _iconsLoaded.putIfAbsent(iconName, () => value);
      });
    });
  }

  Future<BitmapDescriptor> getMarkerImage(
      String name, {int targetWidth}) async {
    assert(name != null);

    // get picture from url - TODO load pictures from assets folder, not internet url
    final File markerImageFile = await DefaultCacheManager().getSingleFile(
        _markerImageUrl[name]
    );
    Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    // get picture from assets
    // ByteData byteData = await rootBundle.load('$url');
    // Uint8List markerImageBytes = Uint8List.view(byteData.buffer);

    if (targetWidth != null) {
      markerImageBytes = await _resizeImageBytes(
        markerImageBytes,
        targetWidth,
      );
    }

    return BitmapDescriptor.fromBytes(markerImageBytes);
  }

  // Resize given [imageBytes] with the [targetWidth].
  static Future<Uint8List> _resizeImageBytes(
      Uint8List imageBytes,
      int targetWidth,
      ) async {
    assert(imageBytes != null);
    assert(targetWidth != null);

    final Codec imageCodec = await instantiateImageCodec(
      imageBytes,
      targetWidth: targetWidth,
    );

    final FrameInfo frameInfo = await imageCodec.getNextFrame();

    final ByteData byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );

    return byteData.buffer.asUint8List();
  }
}