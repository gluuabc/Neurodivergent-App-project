// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  testWidgets('Counter decrements smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the '+' icon twice to increment the counter to 2.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter is at 2.
    expect(find.text('2'), findsOneWidget);

    // Tap the '-' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    // Verify that our counter has decremented.
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Counter resets to 0', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the '+' icon to increment the counter.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter is at 1.
    expect(find.text('1'), findsOneWidget);

    // Tap the 'reset' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Verify that our counter has reset to 0.
    expect(find.text('0'), findsOneWidget);

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}