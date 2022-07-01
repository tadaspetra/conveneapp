// A stateless widget displaying the club name in the app bar

import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersPage extends ConsumerWidget {
  final ClubModel club;
  const MembersPage({Key? key, required this.club}) : super(key: key);

  static MaterialPageRoute<dynamic> route(ClubModel club) => MaterialPageRoute(
        builder: (context) => MembersPage(club: club),
      );

  void _copyClubId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: club.id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Club ID Copied!"),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Members", style: TextStyle(color: Palette.niceBlack)),
        actions: [
          IconButton(
            onPressed: () {
              _copyClubId(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: club.members.length,
          itemBuilder: (context, index) {
            return Text(club.members[index]);
          },
        ),
      ),
    );
  }
}
