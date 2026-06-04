

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cartkaro/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts and renders the MaterialApp.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
