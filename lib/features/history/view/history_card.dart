import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final BookModel book;
  const HistoryCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      padding: const EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0, left: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (book.dateCompleted != null)
                    Row(
                      children: [
                        const Text(
                          'Finished on ',
                        ),
                        Text(
                          DateFormat('MMMM d, yyyy').format(book.dateCompleted!),
                          style: const TextStyle(fontWeight: FontWeight.bold, decorationColor: Palette.niceDarkGrey),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
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
                  if (book.rating != null)
                    RatingBarIndicator(
                      itemSize: 30,
                      rating: book.rating!,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (book.review != null)
                    Text(
                      book.review!,
                    )
                ],
              ),
            ),
          ),
          (book.coverImage == null)
              //if object gets created with no cover image we set to "noimage"
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 20),
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
