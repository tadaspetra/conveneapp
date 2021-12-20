import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/history/controller/history_controller.dart';
import 'package:conveneapp/features/history/view/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends StatelessWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const HistoryPage(),
      );

  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const HistoryView(),
    );
  }
}

class HistoryView extends ConsumerWidget {
  const HistoryView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(historyProvider).map(
          data: (data) {
            if (data.value.isLeft()) {
              return const Center(
                child: Text("Error retrieving books"),
              );
            }
            //trying to get the data if it is right
            List<BookModel> books = data.value.getOrElse(() => []);
            if (books.isEmpty) {
              return const Text(
                "There were no results for history",
              );
            } else {
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, count) {
                  return HistoryCard(book: books[count]);
                },
              );
            }
          },
          loading: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          error: (error) => Center(
            child: Text(error.toString()),
          ),
        );
  }
}
