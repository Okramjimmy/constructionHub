import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:construction_hub/main.dart';

void main() {
  testWidgets('ConstructionHub app launches successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: ConstructionHubApp()),
    );
    // Login page should appear by default
    expect(find.text('ConstructionHub'), findsWidgets);
  });
}
