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
  late FocusNode _reviewFocus;

  @override
  void initState() {
    super.initState();
    _reviewFocus = FocusNode();
  }

  @override
  void dispose() {
    _reviewFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: SearchBookCard(
                    book: SearchBookModel(
                        authors: widget.bookModel.authors,
                        coverImage: widget.bookModel.coverImage,
                        pageCount: widget.bookModel.pageCount,
                        title: widget.bookModel.title)),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20),
                child: Text(
                  "Rate this book",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                    _reviewFocus.requestFocus();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 40),
                child: TextField(
                  controller: _reviewController,
                  minLines: 5,
                  maxLines: null,
                  focusNode: _reviewFocus,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "Add your review of this book",
                    fillColor: Palette.niceGrey,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Palette.niceGrey, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Palette.niceGrey, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Palette.niceGrey, width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Finish adding book to your history?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
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
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("Please add a review")));
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
            ],
          ),
        ),
      ),
    );
  }
}
