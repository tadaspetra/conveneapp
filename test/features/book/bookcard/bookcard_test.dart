import 'package:conveneapp/features/book/view/book_card.dart';
import 'package:conveneapp/features/book/view/book_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import 'bookcard_data.dart';

void main() {
  testWidgets('Should display BookSlidable when BookModel and userId is passed', (WidgetTester tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(const ProviderScope(
          child: MaterialApp(
              home: Scaffold(
                  body: BookSlidable(
        book: bookModel,
      )))));

      expect(find.byType(Slidable), findsOneWidget);
    });
  });

  testWidgets('Should display BookCard when BookModel is passed', (WidgetTester tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: BookCard(book: bookModel))));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('89'), findsOneWidget);
      expect(find.text('Test Book'), findsOneWidget);
    });
  });
}
