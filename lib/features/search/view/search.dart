import 'package:conveneapp/apis/books_finder/books_finder.dart';
import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/features/search/view/search_book_card.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController bookController = TextEditingController();

  String? searchText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Palette.niceGrey,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      decoration: const InputDecoration.collapsed(hintText: "Search Book"),
                      controller: bookController,
                      onSubmitted: (_) async {
                        searchText = bookController.text;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    searchText = bookController.text;
                    setState(() {});
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          if (searchText == null)
            const DefaultView(
              text: "Enter something into search",
            )
          else
            SearchView(
              search: searchText!,
            )
        ],
      ),
    );
  }
}

class DefaultView extends StatelessWidget {
  final String text;
  const DefaultView({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: CustomText(
          text: text,
        ),
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  final String search;
  const SearchView({
    Key? key,
    required this.search,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BooksFinderApi().searchBooks(search),
      builder: (BuildContext context, AsyncSnapshot<List<SearchBookModel>> booklist) {
        if (booklist.connectionState == ConnectionState.done) {
          if (booklist.hasData) {
            return Expanded(
              child: ListView.builder(
                itemCount: booklist.data!.length,
                itemBuilder: (context, count) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, booklist.data![count]);
                    },
                    child: SearchBookCard(book: booklist.data![count]),
                  );
                },
              ),
            );
          } else {
            return const DefaultView(
              text: "There were no results for this search",
            );
          }
        } else {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
