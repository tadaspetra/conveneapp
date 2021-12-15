import 'package:conveneapp/apis/firebase/book.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/history/view/history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const HistoryPage(),
      );
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: HistoryView(),
    );
  }
}

class HistoryView extends ConsumerWidget {
  const HistoryView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return FutureBuilder(
      future: ref.read(bookApiProvider).getHistoryBooks(),
      builder: (BuildContext context, AsyncSnapshot<List<BookModel>> booklist) {
        if (booklist.connectionState == ConnectionState.done) {
          if (booklist.hasData && booklist.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: booklist.data!.length,
              itemBuilder: (context, count) {
                return HistoryCard(book: booklist.data![count]);
              },
            );
          } else {
            return const Text(
              "There were no results for history",
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
