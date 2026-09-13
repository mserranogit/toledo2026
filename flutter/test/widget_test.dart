import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toledo_mobile/main.dart';

void main() {
  testWidgets('Toledo App Smoke Test', (WidgetTester tester) async {
    // Build ToledoApp wrapped in ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: ToledoApp(),
      ),
    );

    // Verify presence of title
    expect(find.text('TOLEDO 2026'), findsOneWidget);
  });
}
