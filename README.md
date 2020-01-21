# flatmapp

Flutter geolocation manager. Choose actions and set their geolocation trigger.

Previous versions:
* 

Current version:
* **v0.1:** google map example created

Incoming version:
* 

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
* Flutter requires **Android Studio** for Android deployment. 
    
    Recommended IDLE to code is **Intellij IDEA**.
    
* Remember to install **Flutter** plugin, following [these instructions](https://flutter.dev/docs/get-started/install).
* install packages required for this project with `flutter pub get`, run in **your project folder!**

    Any additional packages should be implemented in **pubspec.yaml file** and installed as written above.

### Tutorials

Flutter app design: 
[interface](https://flutter.dev/docs/development/ui/widgets-intro) | 
[architecture](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple) |
[testing](https://flutter.dev/docs/testing)

Optimization: [app size](https://flutter.dev/docs/perf/app-size) | [performance](https://flutter.dev/docs/perf/rendering/best-practices)

Google Maps: 
[medium.com](https://medium.com/coletiv-stories/how-to-cluster-markers-on-flutter-google-maps-44620f607de3) | 
[flutter_map_marker_cluster](https://pub.dev/packages/flutter_map_marker_cluster) | 
[flutter_map](https://pub.dev/packages/flutter_map)

### API keys
FlatMapp requires Google Maps API key to get world map for visualisation purposes.
Key is used once every time user opens application 
 - checking localization and activating triggers should occur without API calls.

[API keys](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#3) | 
[Google Maps API key pricing](https://cloud.google.com/maps-platform/pricing/)

### Map usage

[Put Google on the Map](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#5)

### Technical details
* FlatMApp current min SDKVersion (Android level) is 18.
* App main colour is `HEX: 4CAF50` or `RGBA: 76 175 80 100`.
* Custom icons were created in [Android Asset Studio Launcher icon generator](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html#foreground.type=clipart&foreground.clipart=location_on&foreground.space.trim=0&foreground.space.pad=0.3&foreColor=rgb(76%2C%20175%2C%2080)&backColor=rgb(255%2C%20255%2C%20255)&crop=0&backgroundShape=circle&effects=elevate&name=ic_launcher).
* No custom icons for iOS are developed yet.
* New screens (or views) should be operated by Navigator as in [this example](https://flutter.dev/docs/cookbook/navigation/navigation-basics).

### Objects

### Views

## Notes
### Design

### Debugging notes

### On reading Future values

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
