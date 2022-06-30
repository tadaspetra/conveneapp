import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/core/info_button.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/book/controller/book_controller.dart';
import 'package:conveneapp/features/book/view/book_slidable.dart';
import 'package:conveneapp/features/club/controller/club_controller.dart';
import 'package:conveneapp/features/club/view/club_card.dart';
import 'package:conveneapp/features/create_club/view/create_club_page.dart';
import 'package:conveneapp/features/dashboard/controller/user_info_controller.dart';
import 'package:conveneapp/features/history/view/history_page.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/features/search/view/search.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(71.0),
        child: AppBar(
          flexibleSpace: Container(),
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Builder(
              builder: (context) {
                final displayName = ref.watch(currentUserController).asData?.value.name ?? '';
                if (displayName == "") {
                  return const Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  );
                }
                return Text(
                  "Hi, $displayName!",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                );
              },
            ),
          ),
          elevation: 0,
          centerTitle: false,
          actions: [
            Builder(
              builder: (context) {
                return GestureDetector(
                  key: const Key('dashBoard-openDrawer'),
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 15),
                    child: CircleAvatar(
                      backgroundColor: Palette.niceBlack,
                      radius: 24,
                      child: Builder(
                        builder: (context) {
                          final userName = ref.watch(currentUserController).asData?.value.name;
                          if (userName != null) {
                            return Text(userName.substring(0, 1));
                          }

                          return const Icon(Icons.settings);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: const _DashBoardBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BigButton(
          key: const Key('dashBoard-addPersonalBook'),
          child: const Text("New Reading Journey"),
          onPressed: () {
            bottomSheetActions(context, ref);
          }),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, HistoryPage.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await ref.read(authApiProvider).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> bottomSheetActions(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextButton(
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Palette.niceDarkGrey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              InfoButton(
                action: 'Add Personal Book',
                info: 'Add a personal book to your dashboard, so you can track your reading',
                onPressed: () async {
                  Navigator.pop(context);
                  final bookToAdd = await Navigator.push(context, SearchPage.route());
                  if (bookToAdd is SearchBookModel) {
                    await ref.read(currentBooksController.notifier).addBook(
                          book: bookToAdd,
                        );
                  }
                },
              ),
              const SizedBox(height: 10),
              InfoButton(
                action: 'Create a Club',
                info: 'By creating a club, you can invite friends to read together',
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(context, CreateClubPage.route());
                },
              ),
              const SizedBox(height: 10),
              InfoButton(
                action: 'Join a Club',
                info: 'By joining a club, you can read books together with your friends',
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          );
        });
  }
}

/// - Error state is not needed since all the errors are properly handled by the
/// notifier
class _DashBoardBody extends ConsumerWidget {
  const _DashBoardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<CurrentBookListState>>(currentBooksController, (previous, next) {
      next.mapOrNull(
        data: (data) {
          final state = data.value;
          // show a snackbar when this is not null,
          // will not be null if any transaction in the notifier had an error
          if (state.failureMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(
                state.failureMessage!,
              )));
          }
        },
      );
    });
    ref.listen<AsyncValue<CurrentClubListState>>(currentClubsController, (previous, next) {
      next.mapOrNull(
        data: (data) {
          final state = data.value;
          // show a snackbar when this is not null,
          // will not be null if any transaction in the notifier had an error
          if (state.failureMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(
                state.failureMessage!,
              )));
          }
        },
      );
    });
    return ref.watch(currentBooksController).maybeMap(
      orElse: () {
        return const Center(
          key: Key('dashBoard-loading'),
          child: CircularProgressIndicator(),
        );
      },
      data: (bookData) {
        return ref.watch(currentClubsController).maybeMap(orElse: () {
          return const Center(
            key: Key('dashBoard-loading'),
            child: CircularProgressIndicator(),
          );
        }, data: (clubData) {
          final books = bookData.value.books;
          final clubs = clubData.value.clubs;
          // - render a message when the books are empty,
          // - user can be a new user or he doesnt have any books added
          if (books.isEmpty && clubs.isEmpty) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image(
                    image: const AssetImage("assets/defaultstates/empty dashboard.png"),
                    height: (MediaQuery.of(context).size.height * 0.3),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Looks like you aren’t reading any books currently',
                ),
              ],
            ));
          }
          if (books.isEmpty && clubs.isNotEmpty) {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 20),
                        child: Text(
                          'Your current clubs',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            itemCount: clubs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              return ClubCard(
                                club: clubs[index],
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ref.watch(userInfoController).maybeWhen(
                      data: (user) {
                        if (user.showTutorial) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              children: [
                                const Text(
                                  "Swipe The Cards Below",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    ref.read(userApiProvider).removeTutorial(uid: user.uid);
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                      orElse: () {
                        return Container();
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 20),
                      child: Text(
                        'You are currently reading',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          itemCount: books.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return BookSlidable(
                              book: books[index],
                            );
                          }),
                    ),
                    if (clubs.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 20),
                        child: Text(
                          'Your current clubs',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                          itemCount: clubs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, index) {
                            return ClubCard(
                              club: clubs[index],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
