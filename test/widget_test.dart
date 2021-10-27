// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:conveneapp/features/book/view/book_card.dart';
import 'package:conveneapp/features/book/view/book_slidable.dart';
import 'package:conveneapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import 'test_data.dart';

void main() {
  testWidgets('empty test for generating coverage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });

  testWidgets('Should display BookSlidable when BookModel and userId is passed', (WidgetTester tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
              home: Scaffold(
                  body: BookSlidable(
        book: bookModel,
        userId: userModel.uid,
      )))));

      expect(find.byType(Slidable), findsOneWidget);
    });
  });

  testWidgets('Should display BookCard when BookModel is passed', (WidgetTester tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: BookCard(book: bookModel))));

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('89'), findsOneWidget);
      expect(find.text('Test Book'), findsOneWidget);
    });
  });
}
