import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

Future<bool?> deleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Palette.niceRed),
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
      );
    },
  );
}

Future<bool?> finishDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Finish Book'),
        content: const Text('Continue adding book to your history?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
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
      );
    },
  );
}

Future<String?> updateDialog(BuildContext context, BookModel book) {
  TextEditingController currentPage = TextEditingController(text: book.currentPage.toString());
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Book'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: currentPage,
              decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(color: Palette.niceBlack),
                  labelText: "Update page number",
                  hintText: "Update page number"),
              style: const TextStyle(decorationColor: Palette.niceDarkGrey),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(currentPage.text);
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Palette.niceGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: const Text(
              'No',
              style: TextStyle(color: Palette.niceBlack),
            ),
          ),
        ],
      );
    },
  );
}
