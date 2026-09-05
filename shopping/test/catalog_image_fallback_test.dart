import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopping/widgets/home_widgets/catalog_image.dart';

void main() {
  testWidgets(
    'Catalog image falls back to a placeholder when the remote URL fails',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CatalogImage(image: 'https://example.com/not-found.png'),
          ),
        ),
      );

      await tester.pump();

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    },
  );
}
