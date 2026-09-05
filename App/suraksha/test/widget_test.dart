import 'package:flutter_test/flutter_test.dart';
import 'package:suraksha/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check if Safety App title exists
    expect(find.text('Safety App'), findsOneWidget);

    // Check if toggle exists
    expect(find.text('SOS Active'), findsOneWidget);
  });
}