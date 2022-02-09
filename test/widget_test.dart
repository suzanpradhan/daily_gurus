// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dailygurus/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dailygurus/main.dart';

void main() {
  testWidgets('Welcome Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify all Text
    expect(find.text('Welcome to Dailygurus'), findsOneWidget);
    expect(find.text('Get Home Delivery'), findsOneWidget);
    expect(find.text('The whole grocery store at'), findsOneWidget);
    expect(find.text('your fingertips'), findsOneWidget);

    // SIGN IN BUTTON.
    expect(find.text('SIGN IN'), findsOneWidget);

    // REGISTER BUTTON
    expect(find.text('CREATE AN ACCOUNT'), findsOneWidget);
  });
}
