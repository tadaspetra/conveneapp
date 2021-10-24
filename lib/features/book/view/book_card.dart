import 'package:conveneapp/core/text.dart';

import 'package:conveneapp/features/book/controller/book_controller.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../top_level_providers.dart';

class BookCard extends ConsumerWidget {
  final BookModel book;
  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController currentPage =
        TextEditingController(text: book.currentPage.toString());

    bool isStringANumber(String? string) {
      // Null or empty string is not a number
      if (string == null || string.isEmpty) {
        return false;
      }

      // Try to parse input string to number.
      // Both integer and double work.
      // Use int.tryParse if you want to check integer only.
      // Use double.tryParse if you want to check double only.
      final number = num.tryParse(string);

      if (number == null) {
        return false;
      }

      return true;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          (book.coverImage == null)
              //if object gets created with no cover image we set to "noimage"
              ? Container()
              : Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3,
                        spreadRadius: -3,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      book.coverImage!,
                      width: 60,
                      height: 90,
                      cacheWidth: 80,
                      cacheHeight: 120,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: CustomText(text: book.title)),
                  if (book.authors.isNotEmpty)
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(book.authors[0]),
                    )),
                ],
              ),
            ),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 6,
                      color: Palette.niceDarkGrey,
                    ),
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(
                    child: CircularProgressIndicator(
                      value: book.currentPage / book.pageCount,
                      strokeWidth: 6,
                      color: Palette.niceBlack,
                    ),
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(
                    width: 40,
                    child: TextField(
                        textAlign: TextAlign.center,
                        controller: currentPage,
                        decoration:
                            const InputDecoration.collapsed(hintText: "#"),
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Palette.niceDarkGrey),
                        onSubmitted: (string) {
                          if (!isStringANumber(string)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "You need to enter a number for Current Page value"),
                              ),
                            );
                            return;
                          }
                          final data =
                              ref.read(authStateNotifierProvider).userStream.value;
                          ref
                              .read(currentBooksController(data!.uid).notifier)
                              .updateBook(
                                  book: book.copyWith(
                                      currentPage:
                                          int.parse(currentPage.text)));
                        }),
                  ),
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
