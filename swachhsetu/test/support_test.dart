import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swachhsetu/features/support/presentation/support_screen.dart';

void main() {
  testWidgets('support renders FAQ and support form', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SupportScreen()));
    expect(find.text('Frequently asked questions'), findsOneWidget);
    expect(find.text('Contact Support'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Submit support request'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Submit support request'), findsOneWidget);
  });
}
