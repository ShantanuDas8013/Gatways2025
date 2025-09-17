// This file contains tests for the Event App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gateways_app/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds successfully and shows the splash screen
    expect(find.byType(MaterialApp), findsOneWidget);

    // Wait for the splash screen timer to complete (5 seconds)
    await tester.pump(const Duration(seconds: 5));

    // The app should have navigated to the welcome screen
    // We can't easily test the navigation in this basic test
  });
}
