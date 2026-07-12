import 'package:flutter/material.dart';
import 'package:docscan_app/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts without crash', (WidgetTester tester) async {
    await tester.pumpWidget(const app.DocScanApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}