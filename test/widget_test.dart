import 'package:flutter_test/flutter_test.dart';
import 'package:food_safety_new/app/app.dart';

void main() {
  testWidgets('FoodSafeApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodSafeApp());
    expect(find.text('FoodSafe AI'), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('Scan Your Food'), findsOneWidget);
  });
}
