//import 'package:flutter/material.dart';
//import 'package:flutter_test/flutter_test.dart';
//
//import 'package:flatmapp/resources/objects/loaders/markers_loader.dart';
//import 'package:preferences/preference_service.dart';
//import 'package:flatmapp/resources/routes/MapRoute.dart';
//import 'package:flatmapp/main.dart';
//
//Future<void> main()
//async {
//  TestWidgetsFlutterBinding.ensureInitialized();
//  await PrefService.init(prefix: 'pref_');
//  testWidgets('Checking if MapRoute wiget can be loaded',
//          (WidgetTester tester) async {
//        final markerLoader = MarkerLoader();
//        await tester.pumpWidget(
//          MaterialApp(
//              routes: {
//                '/about': (context) => MapRoute(markerLoader),
//              },
//              home: MapRoute(markerLoader)
//          ),
//        );
//        expect(find.byType(MapRoute), findsOneWidget);
//      });
//}