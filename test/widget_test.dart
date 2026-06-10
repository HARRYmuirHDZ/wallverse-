import 'package:flutter_test/flutter_test.dart';
import 'package:wallverse/main.dart';

void main() {
  testWidgets('WallVerse app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WallVerseApp());
    expect(find.text('WallVerse'), findsOneWidget);
  });
}
