import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/features/authentication/model/user.dart';
import 'package:conveneapp/features/book/controller/book_controller.dart';
import 'package:conveneapp/features/book/view/book_slidable.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:conveneapp/features/search/view/search.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerStatefulWidget {
  final LocalUser user;
  const Dashboard({Key? key, required this.user}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(71.0),
        child: AppBar(
          flexibleSpace: Container(),
          title: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              "Hi, ${widget.user.name}!",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          elevation: 0,
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () {
                _scaffoldkey.currentState!.openEndDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 15),
                child: CircleAvatar(
                  backgroundColor: Palette.niceBlack,
                  radius: 24,
                  child: Text(widget.user.name!.substring(0, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          ref.watch(currentBooksController).when(
            error: (Object error, StackTrace? stackTrace) {
              return SliverList(
                delegate: SliverChildListDelegate([const Text("Error retrieving books")]),
              );
            },
            loading: () {
              return SliverList(
                delegate: SliverChildListDelegate([const Center(child: CircularProgressIndicator())]),
              );
            },
            data: (CurrentBookListState value) {
              return SliverList(
                delegate: SliverChildListDelegate([
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
                        itemCount: value.books.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, index) {
                          return BookSlidable(book: value.books[index], userId: widget.user.uid);
                        }),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ]),
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BigButton(
          child: const Text("Add personal book"),
          onPressed: () async {
            final bookToAdd = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => const SearchPage(), fullscreenDialog: true));
            if (bookToAdd is SearchBookModel) {
              await ref.read(currentBooksController.notifier).addBook(book: bookToAdd);
            }
          }),
      endDrawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await ref.read(authApiProvider).signOut();
            },
          ),
        ],
      )),
    );
  }
}
