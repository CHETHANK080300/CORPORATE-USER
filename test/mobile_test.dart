import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corporate_banking_dashboard/main.dart';

void main() {
  testWidgets('Renders properly on desktop screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CorporateBankingApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('VIETNAM BANK'), findsWidgets);
  });

  testWidgets('Renders properly on mobile screen width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CorporateBankingApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('VIETNAM BANK'), findsWidgets);
  });
}
