# FlatMapp

Flutter geolocation manager. Choose actions and set their geolocation trigger.

Previous versions:
* **v0.1:** google map example created
* **v0.2:** basic interface introduced

**Current version:**
* **v0.3:** basic geotrigger

Incoming versions:
* **v0.4:** server communication
* **v0.5:** rebuild
* **v0.6:** actions recommendation system
* **v0.7:** interface enhancements
* **v0.8:** new actions package
* **v0.9:** rebuild
* **v1.0:** release


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Installing project

* Download repository to your desired location. 
* Project requires **Android Studio** for Android deployment and Flutter SDK. 
* Instructions for installing both is under following [link](https://flutter.dev/docs/get-started/install).

    Recommended IDLE to code is **Android Studio**.

* install packages required for this project with `flutter pub get`, run in **your project folder!**

    Any additional packages should be implemented in **pubspec.yaml file** and installed as written above.

## Tutorials

Flutter app design: 
* [Cookbook](https://flutter.dev/docs/cookbook)
* [interface](https://flutter.dev/docs/development/ui/widgets-intro)
* [architecture](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)
* [testing](https://flutter.dev/docs/testing)

* *preferences* package
[libraries](https://pub.dev/documentation/preferences/latest/index.html) |
[example code](https://gitlab.com/redsolver/preferences/blob/master/example/lib/main.dart)

Optimization: 
* [app size](https://flutter.dev/docs/perf/app-size)
* [performance](https://flutter.dev/docs/perf/rendering/best-practices)

Geotrigger: 
* [Trigger readings only upon geolocation change instead of time interval](https://github.com/w3c/geolocation-sensor/issues/13)
* [Geolocation and Geocoding, integrated with Maps](https://medium.com/swlh/working-with-geolocation-and-geocoding-in-flutter-and-integration-with-maps-16fb0bc35ede)
* [Notifications triggered by GPS location](https://stackoverflow.com/questions/55439979/flutter-local-notifications-triggered-by-gps-location)
* [Background geofencing](https://medium.com/flutter/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124)
* [Background location changes handling package](https://github.com/Almoullim/background_location)

Google Maps: 
* [How to cluster markers on Flutter Google Maps](https://medium.com/coletiv-stories/how-to-cluster-markers-on-flutter-google-maps-44620f607de3)

Packages:
* [flutter_map_marker_cluster](https://pub.dev/packages/flutter_map_marker_cluster)
* [flutter_map](https://pub.dev/packages/flutter_map)
* [geolocator](https://pub.dev/packages/geolocator)

## API keys
FlatMapp requires Google Maps API key to get world map for visualisation purposes.
Key is used once every time user opens application 
 - checking localization and activating triggers should occur without API calls.

[API keys](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#3) | 
[Google Maps API key pricing](https://cloud.google.com/maps-platform/pricing/)

## Map usage

[Put Google on the Map](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#5) | 
[Map customization and easy tutorial](https://www.raywenderlich.com/4466319-google-maps-for-flutter-tutorial-getting-started) | 
[Working with geolocation 1](https://medium.com/swlh/working-with-geolocation-and-geocoding-in-flutter-and-integration-with-maps-16fb0bc35ede) |


Drawing documentation:
[shapes](https://developers.google.com/maps/documentation/android-sdk/shapes) | 
[circles](https://pub.dev/documentation/google_maps_flutter/latest/google_maps_flutter/Circle-class.html)

## Technical details
* FlatMApp current min SDKVersion (Android level) is 18.
* App main colour is `HEX: 4CAF50` or `RGBA: 76 175 80 100`.
* Custom map style was created with [Map style with Google tool](https://mapstyle.withgoogle.com)
* Custom icons were created in [Android Asset Studio Launcher icon generator](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html#foreground.type=clipart&foreground.clipart=location_on&foreground.space.trim=0&foreground.space.pad=0.3&foreColor=rgb(76%2C%20175%2C%2080)&backColor=rgb(255%2C%20255%2C%20255)&crop=0&backgroundShape=circle&effects=elevate&name=ic_launcher).
* No custom icons for iOS are developed yet.
* New screens (or views) should be operated by Navigator as in [this example](https://flutter.dev/docs/cookbook/navigation/named-routes).
* Custom loading screen can be added as shown in [this medium tutorial](https://medium.com/@jongzpuangput/flutter-splash-screen-5c8a0001721b).

### Objects
FlatMapp uses objects (classes) to define packages of functions.

Currently FlatMapp uses:
* Loaders:

    * marker_loader - handles management of list of marker objects (adding, editing, deleting and saving to local data storage) 
    * icon_loader - handles icon loading
    * trigger_loader - handles actions calling

* Map:



* Widgets:

    * app_bar - app bar widget, common for all routes;
    * bottom_navigation_bar - navigation bar button to return 
    to the previous route, common for all routes;
    * side_bar_menu - sidebar menu widget, operating access to all routes,
    common for all routes;
    * text_form_fields - widget for adding or editing markers;
    * text_styles - styles for text used in application. 
    Contains *header*, *bodyText* and *footer* styles.

### Routes
Routes are application views. Each new screen presented in the app 
is another route.

Currently FlatMapp uses 5 routes:

1. MapRoute - main view with map;
2. ProfileRoute - view of user profile;
3. SettingsRoute - view of application settings;
4. AboutRoute - about page, presenting basic information about team;
5. LogInRoute- page for logging in to user account,
license and application fundations;

## Debugging notes
### On running dependent tests

If test script depends on outside data (like global PrefService)  
initialized in other classes than tested one, running test script will
result in *MissingPlugin* error.

To avoid this and many other errors, run test script via terminal command:

    flutter run x_test.dart

with emulator opened in the background or phone with usb debug on.

Device will open main app and stop on splash screen view, and terminal
will provide output for test.



### On reading \<Future\> values

Dart utilizes specific form of asynchronous processing, called Future.
Future objects allow application to work while their work is not finished.

Reading Future\<String\> value results in returning "Instance of Future\<String>" response, 
not actual content of variable, due to the asynchronicity thereof.  

If the Future objects are being accessed too fast (before the Future happened), 
application will fail to load them as `null` value would be returned 
(as the object itself exists in the future).

This can be prevented with example coding 
([documentation](https://dart.dev/codelabs/async-await)):

```dart
// use async library
import 'dart:async';
```
```dart
class A {
  Future<int> getInt() {
    return Future.value(10);
  }
}

class B {
  checkValue() async {
    final val = await A().getInt();
    print(val == 10 ? "yes" : "no");
  }
}
```
```dart
void foo() async {
  final user = await _fetchUserInfo(id);
}

Future someMethod() async {
  String s = await someFuncThatReturnsFuture();
}
```
```dart
someMethod() {
  someFuncTahtReturnsFuture().then((s) {
    print(s);
  });
}
```
---
