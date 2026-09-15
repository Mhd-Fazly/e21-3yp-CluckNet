import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clucknet_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App boots and renders Sign In screen', (WidgetTester tester) async {
    // Initialize SharedPreferences with mock values for the test
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CluckNetApp(),
      ),
    );

    // Allow initial microtasks (like SharedPreferences) to run in the fake async zone
    await tester.pump();

    // Let the GoRouter redirect and transitions complete
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the login screen title and sign in header are displayed.
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Quick Demo Accounts'), findsOneWidget);
  });
}
