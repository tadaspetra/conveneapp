import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class SearchBookCard extends StatelessWidget {
  final SearchBookModel book;
  const SearchBookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Palette.niceGrey,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            spreadRadius: -6,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: ((book.coverImage == "noimage") || book.coverImage == null)
                //if object gets created with no cover image we set to "noimage"
                ? Container()
                : Image.network(
                    book.coverImage,
                    width: 80,
                    height: 120,
                    cacheWidth: 80,
                    cacheHeight: 120,
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      book.title,
                      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (book.authors.isNotEmpty) Flexible(child: Text(book.authors[0])),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
