// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather/main.dart';

void main() {
  testWidgets('App launches and displays initial widgets', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial text 'No data' is displayed.
    expect(find.text('No data'), findsOneWidget);
    expect(find.text('Enter location'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  // Future tests can be added here to test weather fetching and display.
}
