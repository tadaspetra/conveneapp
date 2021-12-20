import 'package:conveneapp/features/book/controller/book_controller.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/features/search/view/search_book_card.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinishBookPage extends ConsumerStatefulWidget {
  final BookModel bookModel;
  const FinishBookPage({required this.bookModel, Key? key}) : super(key: key);

  static MaterialPageRoute<dynamic> route(BookModel bookModel) => MaterialPageRoute(
        builder: (context) => FinishBookPage(bookModel: bookModel),
      );

  @override
  _FinishBookPageState createState() => _FinishBookPageState();
}

class _FinishBookPageState extends ConsumerState<FinishBookPage> {
  final TextEditingController _reviewController = TextEditingController();
  double? rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //TODO: There is probably a better way to handle this
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            SearchBookCard(
                book: SearchBookModel(
                    authors: widget.bookModel.authors,
                    coverImage: widget.bookModel.coverImage,
                    pageCount: widget.bookModel.pageCount,
                    title: widget.bookModel.title)),
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Rate this book",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                allowHalfRating: true,
                glowColor: Palette.niceBlack,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextField(
                controller: _reviewController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: "Add your review of this book",
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Finish adding book to your history?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    if (rating == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Need to give book a rating")));
                    } else if (_reviewController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add a review")));
                    } else {
                      ref.read(currentBooksController.notifier).finishBook(
                            book: widget.bookModel.copyWith(
                              rating: rating,
                              review: _reviewController.text,
                            ),
                          );
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Palette.niceBlue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(color: Palette.niceBlack),
                  ),
                ),
              ],
            ),
            const Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
