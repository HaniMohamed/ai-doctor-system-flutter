import 'package:ai_doctor_system/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AIDoctorApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('AI Doctor System'), findsOneWidget);
  });
}


