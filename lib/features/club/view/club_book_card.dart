import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/club/model/club_book_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class ClubBookCard extends StatelessWidget {
  final ClubBookModel book;
  const ClubBookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      padding: const EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0, left: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: CustomText(text: book.title)),
                  if (book.authors.isNotEmpty)
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        book.authors[0],
                        style: const TextStyle(color: Palette.niceDarkGrey),
                      ),
                    )),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
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
        ],
      ),
    );
  }
}
