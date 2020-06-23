import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:preferences/preference_service.dart';
import 'package:flatmapp/resources/routes/AboutRoute.dart';

Future<void> main()
async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  testWidgets('Checking if AboutRoute wiget can be loaded',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
              routes: {
                '/about': (context) => AboutRoute(),
              },
              home: AboutRoute()
          ),
        );

        expect(find.byType(AboutRoute), findsOneWidget);
      });
}