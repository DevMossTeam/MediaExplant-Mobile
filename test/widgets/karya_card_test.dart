import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:karya_app/widgets/karya_card.dart';
import '../../mock/mock_user.dart';

void main() {
  testWidgets('Displays user name and like count', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: KaryaCard(
          user: mockUser,
          likeCount: 5,
          onShare: () {},
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('Triggers share function when share icon tapped', (WidgetTester tester) async {
    bool shared = false;

    await tester.pumpWidget(
      MaterialApp(
        home: KaryaCard(
          user: mockUser,
          likeCount: 10,
          onShare: () {
            shared = true;
          },
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.share));
    await tester.pump();

    expect(shared, isTrue);
  });
}
