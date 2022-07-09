// A stateless widget displaying the club name in the app bar

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/features/club/controller/club_controller.dart';
import 'package:conveneapp/features/club/model/club_book_model.dart';
import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/features/club/view/club_book_card.dart';
import 'package:conveneapp/features/club/view/members_page.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/features/search/view/search.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const twoWeeksInSeconds = 14 * 24 * 60 * 60;

class ClubPage extends ConsumerStatefulWidget {
  final ClubModel club;
  const ClubPage({Key? key, required this.club}) : super(key: key);

  static MaterialPageRoute<dynamic> route(ClubModel club) => MaterialPageRoute(
        builder: (context) => ClubPage(club: club),
      );
  @override
  _ClubState createState() => _ClubState();
}

class _ClubState extends ConsumerState<ClubPage> {
  ClubBookModel? _currentBook;

  @override
  void initState() {
    _currentBook = widget.club.currentBook;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.club.name,
            style: const TextStyle(color: Palette.niceBlack)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MembersPage.route(widget.club));
            },
            icon: const Icon(Icons.people),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_currentBook != null)
            ClubBookCard(book: _currentBook!)
          else
            TextButton(
                onPressed: () async {
                  final bookToAdd =
                      await Navigator.push(context, SearchPage.route());
                  if (bookToAdd is SearchBookModel) {
                    ClubBookModel clubBookToAdd = ClubBookModel(
                      title: bookToAdd.title,
                      authors: bookToAdd.authors,
                      pageCount: bookToAdd.pageCount,
                      coverImage: bookToAdd.coverImage,
                      dueDate: Timestamp.now().seconds +
                          twoWeeksInSeconds, //TODO: make this so that it is configurable
                    );
                    await ref.read(currentClubsController.notifier).addBook(
                          club: widget.club,
                          book: clubBookToAdd,
                        );
                    setState(() {
                      _currentBook = clubBookToAdd;
                    });
                  }
                },
                child: const Text("Select a book")),
        ],
      ),
    );
  }
}
