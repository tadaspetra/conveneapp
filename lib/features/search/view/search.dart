import 'package:conveneapp/apis/books_finder/books_finder.dart';
import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/features/search/view/search_book_card.dart';
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
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "Enter Book"),
                    controller: bookController,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  searchText = bookController.text;
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
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
    return Expanded(
      child: FutureBuilder(
        future: BooksFinderApi().searchBooks(search),
        builder: (BuildContext context, AsyncSnapshot<List<SearchBookModel>> booklist) {
          if (booklist.hasData) {
            return ListView.builder(
              itemCount: booklist.data!.length,
              itemBuilder: (context, count) {
                return SearchBookCard(book: booklist.data![count]);
              },
            );
          } else {
            return const DefaultView(
              text: "There were no results for this search",
            );
          }
        },
      ),
    );
  }
}
