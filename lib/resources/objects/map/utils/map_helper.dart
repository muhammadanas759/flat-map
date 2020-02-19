import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluster/fluster.dart';

import 'package:flatmapp/resources/objects/map/utils/map_marker.dart';


// Encapsulate logic required to get marker icons from url images
// and show clusters using the [Fluster] package.
class MapHelper {
  // If there is a cached file and it's not old, return the cached marker image file
  // If else, download the image and save it on the temp dir and return that file.
  //
  // This mechanism is possible using the [DefaultCacheManager] package and is useful
  // to improve load times on the next map loads.
  // First time will always take more time to download the file and set the marker image.
  //
  // Resize the marker image by providing a [targetWidth].
  static Future<BitmapDescriptor> getMarkerImageFromAssets(
    String url, {
    int targetWidth,
  }) async {
    assert(url != null);

    // get picture from url
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
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

  // Init the cluster manager with all the [MapMarker] to be displayed on the map.
  // set up the cluster marker itself with a [clusterImageUrl].
  // For more info about customizing your clustering logic check the [Fluster] constructor.
  static Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
    int minZoom,
    int maxZoom,
    String clusterImageUrl,
  ) async {
    assert(markers != null);
    assert(minZoom != null);
    assert(maxZoom != null);
    assert(clusterImageUrl != null);

    final BitmapDescriptor clusterImage =
        await MapHelper.getMarkerImageFromAssets(clusterImageUrl);

    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 2048,
      nodeSize: 64,
      points: markers,
      createCluster: (
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
        id: cluster.id.toString(),
        position: LatLng(lat, lng),
        icon: clusterImage,
        isCluster: true,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        childMarkerId: cluster.childMarkerId,
      ),
    );
  }

  // Get list of markers and clusters that reside within the visible
  // bounding box for given [currentZoom].
  // For more info check [Fluster.clusters].
  static List<Marker> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double currentZoom,
  ) {
    assert(currentZoom != null);

    if (clusterManager == null) return [];

    return clusterManager
        .clusters([-180, -85, 180, 85], currentZoom.toInt())
        .map((cluster) => cluster.toMarker())
        .toList();
  }
}
