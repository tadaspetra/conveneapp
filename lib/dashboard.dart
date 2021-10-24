import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/features/authentication/model/user.dart';
import 'package:conveneapp/features/book/controller/book_controller.dart';
import 'package:conveneapp/features/book/model/book_model.dart';
import 'package:conveneapp/features/book/view/book_card.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/features/search/view/search.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:conveneapp/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends ConsumerStatefulWidget {
  final LocalUser user;
  const Dashboard({Key? key, required this.user}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hi ${widget.user.name}",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => AuthApi().signOut(),
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          ref.watch(currentBooksController(widget.user.uid)).when(
            error: (Object error, StackTrace? stackTrace, AsyncData<List<BookModel>>? bookList) {
              return SliverList(
                delegate: SliverChildListDelegate([const Text("Error retrieving books")]),
              );
            },
            loading: (AsyncValue<List<BookModel>>? bookList) {
              return SliverList(
                delegate: SliverChildListDelegate([const Center(child: CircularProgressIndicator())]),
              );
            },
            data: (List<BookModel> value) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Slidable(
                      key: ValueKey(value[index]),
                      child: BookCard(
                        book: value[index],
                      ),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(
                          closeOnCancel: true,
                          onDismissed: () {
                            ref.read(currentBooksController(widget.user.uid).notifier).finishBook(book: value[index]);
                          },
                          confirmDismiss: () async {
                            bool? returnValue = await finishDialog(context);

                            return returnValue!;
                          },
                        ),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              bool? returnValue = await finishDialog(context);
                              if (returnValue == true) {
                                ref
                                    .read(currentBooksController(widget.user.uid).notifier)
                                    .finishBook(book: value[index]);
                              }
                            },
                            backgroundColor: Palette.niceBlue,
                            foregroundColor: Palette.niceWhite,
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
                            ref.read(currentBooksController(widget.user.uid).notifier).deleteBook(book: value[index]);
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
                                ref
                                    .read(currentBooksController(widget.user.uid).notifier)
                                    .deleteBook(book: value[index]);
                              }
                            },
                            backgroundColor: Palette.niceRed,
                            foregroundColor: Palette.niceWhite,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: value.length,
                ),
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final data = ref.read(authStateNotifierProvider).userStream.value;
          var bookToAdd = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SearchPage(), fullscreenDialog: true));
          if (bookToAdd is SearchBookModel) {
            ref.read(currentBooksController(data!.uid).notifier).addBook(book: bookToAdd);
          }
        },
        label: Row(
          children: const [
            Icon(Icons.book_outlined),
            SizedBox(
              width: 10,
            ),
            Text(
              "Add a Book",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
