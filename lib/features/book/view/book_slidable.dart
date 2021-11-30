import 'package:conveneapp/features/book/controller/book_controller.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/book/view/book_card.dart';
import 'package:conveneapp/features/dashboard/view/dashboard_dialogs.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookSlidable extends ConsumerWidget {
  final BookModel book;

  const BookSlidable({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: ValueKey(book),
      child: BookCard(
        book: book,
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          closeOnCancel: true,
          onDismissed: () {},
          confirmDismiss: () async {
            String? returnValue = await updateDialog(context, book);

            if (returnValue != null) {
              ref
                  .read(currentBooksController.notifier)
                  .updateBook(book: book.copyWith(currentPage: int.parse(returnValue)));
            }

            return false;
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) async {
              String? returnValue = await updateDialog(context, book);

              if (returnValue != null) {
                ref
                    .read(currentBooksController.notifier)
                    .updateBook(book: book.copyWith(currentPage: int.parse(returnValue)));
              }
            },
            backgroundColor: Palette.niceWhite,
            foregroundColor: Palette.niceGreen,
            icon: Icons.edit,
            label: 'Update',
          ),
          SlidableAction(
            onPressed: (context) async {
              bool? returnValue = await finishDialog(context);
              if (returnValue == true) {
                ref.read(currentBooksController.notifier).finishBook(book: book);
              }
            },
            backgroundColor: Palette.niceWhite,
            foregroundColor: Palette.niceBlue,
            icon: Icons.check,
            label: 'Finish',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          closeOnCancel: true,
          onDismissed: () {
            ref.read(currentBooksController.notifier).deleteBook(book: book);
          },
          confirmDismiss: () async {
            bool? returnValue = await deleteDialog(context);

            return returnValue!;
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) async {
              bool? returnValue = await deleteDialog(context);
              if (returnValue == true) {
                ref.read(currentBooksController.notifier).deleteBook(book: book);
              }
            },
            backgroundColor: Palette.niceWhite,
            foregroundColor: Palette.niceRed,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
    );
  }
}
