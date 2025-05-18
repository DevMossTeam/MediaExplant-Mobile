import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karya_app/widgets/share_button.dart';

void main() {
  testWidgets('Share button renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ShareButton(onPressed: () {}),
      ),
    );

    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);
  });

  testWidgets('Share button calls callback when pressed', (WidgetTester tester) async {
    bool clicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ShareButton(onPressed: () {
          clicked = true;
        }),
      ),
    );

    await tester.tap(find.byType(ShareButton));
    await tester.pump();

    expect(clicked, isTrue);
  });
}
