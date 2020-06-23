import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:preferences/preference_service.dart';
import 'package:flatmapp/resources/routes/LogInRoute.dart';
import 'package:flatmapp/resources/routes/RegisterRoute.dart';

Future<void> main()
async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  testWidgets('Checking if LogInRoute can be loaded',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
              routes: {
                '/login': (context) => LogInRoute(),
              },
              home: LogInRoute()
          ),
        );
        expect(find.byType(LogInRoute), findsOneWidget);
      });
  testWidgets('Checking if register route works',
  (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/login': (context) => LogInRoute(),
          '/register': (context) => RegisterRoute()
        },
        home: LogInRoute()
      ),
    );
    final emailField = find.byKey(Key('login_email_field_key'));
    final passwordField = find.byKey(Key('login_password_field_key'));
    final registerButton = find.byKey(Key('login_button'));

    await tester.enterText(emailField, "a@a.pl");
    await tester.enterText(passwordField, 'Testowehaslo1!');
    await tester.tap(registerButton);

    await tester.pump();

    expect(find.byType(RegisterRoute), findsOneWidget);
  });
  testWidgets("Checking if password can't be empty",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
              routes: {
                '/login': (context) => LogInRoute(),
              },
              home: LogInRoute()
          ),
        );
        final emailField = find.byKey(Key('login_email_field_key'));
        final passwordField = find.byKey(Key('login_password_field_key'));
        final logInButton = find.byKey(Key('login_button'));

        await tester.enterText(emailField, "a@a.pl");
        await tester.enterText(passwordField, '');
        await tester.tap(logInButton, pointer: 0);
        await tester.pump();
      });
}