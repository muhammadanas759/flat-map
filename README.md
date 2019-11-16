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
    
## Design notes


### Tutorials

[API keys](https://codelabs.developers.google.com/codelabs/google-maps-in-flutter/#3) | 
[medium.com](https://medium.com/coletiv-stories/how-to-cluster-markers-on-flutter-google-maps-44620f607de3) | 
[flutter_map_marker_cluster](https://pub.dev/packages/flutter_map_marker_cluster) | 
[flutter_map](https://pub.dev/packages/flutter_map)


### Technical details
    FlatApp current min SDKVersion (Android level) is 18.
    
    App main colour is `HEX: 0197f8` or `RGBA: 1 151 248 100`.
    
    Custom icons were created in [Android Asset Studio Launcher icon generator](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html#foreground.type=clipart&foreground.clipart=filter_vintage&foreground.space.trim=1&foreground.space.pad=0.25&foreColor=rgb(1%2C%20151%2C%20248)&backColor=rgb(255%2C%20255%2C%20255)&crop=0&backgroundShape=circle&effects=none&name=ic_launcher).
    No custom icons for iOS are developed yet.
    
    New screens (or views) should be operated by Navigator as in [this example](https://flutter.dev/docs/cookbook/navigation/navigation-basics).

### Routes

xoxo

## Debugging notes

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
