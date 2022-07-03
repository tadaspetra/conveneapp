// A stateless widget displaying the club name in the app bar

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

class ClubPage extends ConsumerWidget {
  final ClubModel club;
  const ClubPage({Key? key, required this.club}) : super(key: key);

  static MaterialPageRoute<dynamic> route(ClubModel club) => MaterialPageRoute(
        builder: (context) => ClubPage(club: club),
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(club.name, style: const TextStyle(color: Palette.niceBlack)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MembersPage.route(club));
            },
            icon: const Icon(Icons.people),
          ),
        ],
      ),
      body: Column(
        children: [
          if (club.currentBook != null)
            ClubBookCard(book: club.currentBook!)
          else
            TextButton(
                onPressed: () async {
                  final bookToAdd = await Navigator.push(context, SearchPage.route());
                  if (bookToAdd is SearchBookModel) {
                    await ref.read(currentClubsController.notifier).addBook(
                          club: club,
                          book: ClubBookModel(
                            title: bookToAdd.title,
                            authors: bookToAdd.authors,
                            pageCount: bookToAdd.pageCount,
                            dueDate: DateTime.now().add(
                              //todo: make this time configurable
                              const Duration(days: 14),
                            ),
                          ),
                        );
                  }
                },
                child: const Text("Select a book")),
        ],
      ),
    );
  }
}
