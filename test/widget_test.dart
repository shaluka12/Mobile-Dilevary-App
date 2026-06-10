import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/main.dart';

void main() {
  testWidgets('App onboarding screen renders successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that onboarding title or brand name renders.
    expect(find.text('WELCOME TO GOURMETGO'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
