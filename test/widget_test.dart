import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voyzo/main.dart';

void main() {
  testWidgets('App smoke test — home page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: VoyzoApp()));
    await tester.pumpAndSettle();

    expect(find.text('Voyzo'), findsOneWidget);
  });
}
