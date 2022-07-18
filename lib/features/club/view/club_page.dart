// A stateless widget displaying the club name in the app bar

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/authentication/model/user_info.dart';
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
import 'package:intl/intl.dart';

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
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 14));

  @override
  void initState() {
    _currentBook = widget.club.currentBook;
    _selectedDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedDate.hour,
    );
    super.initState();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2222));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDate.hour,
        );
      });
    }
  }

  Future _selectTime() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 200.0),
          child: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Enter Hour (0-23)"),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            int.parse(value),
                          );
                        });
                      },
                      onEditingComplete: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
            onPressed: () async {
              List<UserInfo> members = [];
              for (var member in widget.club.members) {
                UserInfo user =
                    await ref.watch(userApiProvider).getFutureUser(uid: member);
                members.add(user);
              }
              Navigator.push(context, MembersPage.route(widget.club, members));
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
            Column(
              children: [
                const Text(
                  "Select time for next club meeting:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat.yMMMMd("en_US").format(_selectedDate)),
                    const SizedBox(width: 50),
                    Text(DateFormat("H:00").format(_selectedDate)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectDate(),
                        child: const Text("Change Date"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _selectTime(),
                        child: const Text("Change Time"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final bookToAdd =
                              await Navigator.push(context, SearchPage.route());
                          if (bookToAdd is SearchBookModel) {
                            ClubBookModel clubBookToAdd = ClubBookModel(
                              title: bookToAdd.title,
                              authors: bookToAdd.authors,
                              pageCount: bookToAdd.pageCount,
                              coverImage: bookToAdd.coverImage,
                              dueDate:
                                  Timestamp.fromDate(_selectedDate).seconds,
                            );
                            await ref
                                .read(currentClubsController.notifier)
                                .addBook(
                                  club: widget.club,
                                  book: clubBookToAdd,
                                );
                            setState(() {
                              _currentBook = clubBookToAdd;
                            });
                          }
                        },
                        child: const Text("Select a book"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          Center(
            child: TextButton(
              onPressed: () async {
                final userId =
                    ref.watch(currentUserController).asData?.value.uid;
                await ref.read(currentClubsController.notifier).removeFromClub(
                      club: widget.club,
                      memberId: userId!,
                    );
                Navigator.pop(context);
              },
              child: const Text("Leave Club"),
            ),
          )
        ],
      ),
    );
  }
}
