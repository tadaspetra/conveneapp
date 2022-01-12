import 'package:conveneapp/main.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('empty test for generating coverage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
