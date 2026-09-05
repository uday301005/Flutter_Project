import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swachhsetu/features/profile/presentation/profile_screen.dart';

void main() {
  testWidgets('profile renders editable profile fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ProfileScreen())),
    );
    await tester.pump();
    expect(find.text('Profile'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Name'), findsOneWidget);
    expect(find.text('Save changes'), findsOneWidget);
  });
}
