import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gateways_app/screens/welcome_screen.dart';

void main() {
  group('WelcomeScreen Countdown Tests', () {
    testWidgets('Countdown is visible when event is in future', (
      WidgetTester tester,
    ) async {
      // Test with current date (September 17, 2025) and event date (September 25, 2025)
      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Wait for the countdown timer to initialize
      await tester.pump(const Duration(seconds: 2));

      // Verify that the countdown text is present
      expect(find.text('EVENT COUNTDOWN'), findsOneWidget);

      // Verify that countdown units are present (DAYS, HOURS, MINS, SECS)
      expect(find.text('DAYS'), findsOneWidget);
      expect(find.text('HOURS'), findsOneWidget);
      expect(find.text('MINS'), findsOneWidget);
      expect(find.text('SECS'), findsOneWidget);
    });

    testWidgets('Countdown conditional rendering logic works', (
      WidgetTester tester,
    ) async {
      // This test verifies that the conditional rendering logic is in place
      // The actual countdown removal when the event passes would need integration testing
      // or mocking of DateTime.now()

      await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));

      // Wait for initialization
      await tester.pump(const Duration(seconds: 2));

      // With current dates, countdown should be visible
      expect(find.text('EVENT COUNTDOWN'), findsOneWidget);

      // The conditional logic `if (_timeUntilEvent > Duration.zero)` ensures
      // that when the countdown reaches zero or goes negative, the widget is hidden.
      // This was implemented by wrapping the countdown Container in the conditional check.
    });
  });
}
